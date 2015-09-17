class AddDirectionToTrains < ActiveRecord::Migration
  def change
    add_column :trains, :direction, :string
  end
end
