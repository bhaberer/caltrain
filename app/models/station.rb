# Class to manage Station information
class Station < ActiveRecord::Base
  has_many :stops, dependent: :destroy
  has_many :trains, through: :stops

  validates :name, presence: true
  validates :zone, presence: true,
                   numericality: true
  validates :order, presence: true,
                    numericality: true

  after_create :generate_uid

  def first?
    order.zero?
  end

  def last?
    order == (Station.count - 1)
  end

  def generate_uid
    update_attribute(:uid, name.downcase.gsub(/\s/, '_').gsub(/\W/, ''))
  end

  def to_param
    uid
  end

  def self.find_by_param(input)
    find_by_uid(input)
  end
end
