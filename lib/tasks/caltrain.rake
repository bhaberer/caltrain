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
  end
end
