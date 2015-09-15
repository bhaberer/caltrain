class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.datetime :time
      t.belongs_to :train, index: true, foreign_key: true
      t.belongs_to :station, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
