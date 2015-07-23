namespace :caltrain do
  namespace :purge do
    desc 'Purge all Stations'
    task stations: :environment do
      Station.all.each(&:destroy)
    end

    desc 'Purge all Trains'
    task trains: :environment do
      Train.all.each(&:destroy)
    end

    desc 'Purge all Stops'
    task stops: :environment do
      Stop.all.each(&:destroy)
    end
  end

  namespace :populate do
    desc 'populate the Stations based on the stations.yml'
    task stations: :environment do
      File.open(Rails.root.join('lib', 'tasks', 'stations.yml')) do |file|
        stations = YAML.load_file(file)
        stations.each { |station| Station.create!(station) }
      end
    end

    desc 'populate the Trains based on the trains.yml'
    task trains: :environment do
      File.open(Rails.root.join('lib', 'tasks', 'trains.yml')) do |file|
        trains = YAML.load_file(file)
        trains.each { |train| Train.create!(train) }
      end
    end

    task stops_file: :environment do
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id = ENV['GOOGLE_ID']
      auth.client_secret = ENV['GOOGLE_SECRET']
      auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/"
      ]
      auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      auth.code = $stdin.gets.chomp
      auth.fetch_access_token!
      access_token = auth.access_token
      session = GoogleDrive.login_with_oauth(access_token)
      sheet = session.spreadsheet_by_key(ENV['GOOGLE_SHEET'])
      stops = download_stops(sheet)
      File.open(Rails.root.join('lib', 'tasks', 'stops.yml'), 'w') do |file|
         file.puts(YAML.dump(stops.symbolize_keys))
      end
    end

    desc 'pupulate stops based of stops.yml'
    task stops: :environment do
      File.open(Rails.root.join('lib', 'tasks', 'stops.yml')) do |file|
        stops = YAML.load_file(file)
        stops.each_pair do |train_num, times|
          train = Train.find_or_create_by(number: train_num.to_s.to_i)
          train.save
          times.each_with_index do |time, order_number|
            next if time == 'NONE'
            station = Station.where(order: order_number).first
            fail if station.nil? || train.nil?
            stop = Stop.create!(time: time, station: station, train: train,
                                direction: train.south? ? 'south' : 'north')
          end
        end
      end
    end
  end

  def download_stops(sheet)
    all_stops = {}
    (0..3).each do |sheet_num|
      ws = sheet.worksheets[sheet_num]
      (2..60).each do |col|
        if ws[1, col][/\d{3}/]
          train_num = ws[1, col]
          stops = []
          (2..(Station.count + 2)).each do |row|
            stop = ws[row, col]
            stops << stop unless stop.blank?
          end
          all_stops[train_num.to_s.to_i] = stops
        end
      end
    end
    all_stops
  end
end
