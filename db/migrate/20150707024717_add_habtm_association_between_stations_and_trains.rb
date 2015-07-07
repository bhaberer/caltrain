class AddHabtmAssociationBetweenStationsAndTrains < ActiveRecord::Migration
  def change
    create_table :stations_trains, id: false do |t|
      t.belongs_to :station, index: true
      t.belongs_to :train, index: true
    end
  end
end
