class AddUidToStations < ActiveRecord::Migration
  def change
    add_column :stations, :uid, :string
  end
end
