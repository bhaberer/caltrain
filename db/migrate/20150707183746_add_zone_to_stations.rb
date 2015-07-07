class AddZoneToStations < ActiveRecord::Migration
  def change
    add_column :stations, :zone, :integer
  end
end
