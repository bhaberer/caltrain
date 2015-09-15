namespace :caltrain do
  desc 'Refresh all static data, purges all stops, stations and trains and'\
       'reinitializes all data from current yml files'
  task refresh: :environment do
    []
    Rake::Task['task_name'].invoke
  end

  namespace :purge do
    desc 'Purge stations, stops and trains.'
    task all: [:environment, :stops, :stations, :trains] do
      puts 'Done.'
    end

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
    desc 'Populate stations, stops and trains.'
    task all: [:environment, :stations, :trains, :stops] do
      puts 'Done.'
    end

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
        'https://www.googleapis.com/auth/drive',
        'https://spreadsheets.google.com/feeds/'
      ]
      auth.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
      print("1. Open this page:\n#{auth.authorization_uri}\n\n")
      print('2. Enter the authorization code shown in the page: ')
      auth.code = $stdin.gets.chomp
      auth.fetch_access_token!
      access_token = auth.access_token
      session = GoogleDrive.login_with_oauth(access_token)
      sheet = session.spreadsheet_by_key(ENV['GOOGLE_SHEET'])
      stops = StopsIngestor.download_stops(sheet)
      File.open(Rails.root.join('lib', 'tasks', 'stops.yml'), 'w') do |file|
        file.puts(YAML.dump(stops.symbolize_keys))
      end
    end

    desc 'pupulate stops based of stops.yml'
    task stops: :environment do
      File.open(Rails.root.join('lib', 'tasks', 'stops.yml')) do |file|
        stops = YAML.load_file(file)
        stops.each_pair do |train_num, times|
          train = Train.where(number: train_num.to_s.to_i).first
          times.each_with_index do |time, order_number|
            next if time == 'NONE'
            puts "#{time} +0800"
            time = Time.parse("#{time} +0800")
            puts time
            station = Station.where(sequence: order_number).first
            fail if station.nil? || train.nil?
            Stop.create!(time: time, station: station,
                         train: train, direction: train.south? ? 'south' : 'north')
          end
        end
      end
    end
  end
end

# Small module to manage pulling fresh info from gdoc.
module StopsIngestor
  STOP_ROWS = 35
  MAX_TRAINS_PER_SHEET = 60
  TRAIN_NUM_ROW = 1

  def self.download_stops(sheet)
    all_stops = {}
    sheet.worksheets.each do |ws|
      stops = parse_sheet(ws)
      all_stops.merge(stops)
    end
    all_stops
  end

  private

  def parse_sheet(sheet)
    stops = {}
    (2..MAX_TRAINS_PER_SHEET).each do |col|
      next unless sheet[TRAIN_NUM_ROW, col][/\d{3}/]
      train_num = sheet[TRAIN_NUM_ROW, col].to_s.to_i
      stop_list = parse_train(col, sheet)
      stops[train_num] = stop_list
    end
    stops
  end

  def parse_train(col, sheet)
    stop_list = []
    (2..STOP_ROWS).each do |row|
      next if sheet[row, col].blank?
      stop_list << sheet[row, col]
    end
  end
end
