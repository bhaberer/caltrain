class ChangeStationOrderToSequence < ActiveRecord::Migration
  def change
    rename_column :stations, :order, :sequence
  end
end
