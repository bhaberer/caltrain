class Stop < ActiveRecord::Base
  belongs_to :train
  belongs_to :station

  validates :train, presence: true
  validates :station, presence: true
end
