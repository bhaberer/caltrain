class AddOriginTimeToTrains < ActiveRecord::Migration
  def change
    add_column :trains, :origin_time, :datetime
  end
end
