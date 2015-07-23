class Stop < ActiveRecord::Base
  belongs_to :train
  belongs_to :station
  delegate :number, to: :train, prefix: true
  delegate :name, to: :station, prefix: true


  validates :train, presence: true
  validates :station, presence: true
  validates :direction, presence: true,
                        inclusion: { in: %w(south north) }
end
