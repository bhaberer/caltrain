# Class to manage Station information
class Station < ActiveRecord::Base
  has_many :stops, dependent: :destroy

  validates :name, presence: true
  validates :zone, presence: true,
                   numericality: true
  validates :order, presence: true,
                    numericality: true
end
