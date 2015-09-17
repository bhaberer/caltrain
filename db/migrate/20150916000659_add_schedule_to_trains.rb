class AddScheduleToTrains < ActiveRecord::Migration
  def change
    add_column :trains, :schedule, :string
  end
end
