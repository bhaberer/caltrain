# Class to manage Train information
class Train < ActiveRecord::Base
  has_many :stops, dependent: :destroy
  has_many :stations, through: :stops

  validates :schedule, presence: true,
                      inclusion: { in: %w(weekday weekend) }
  validates :direction, presence: true,
                        inclusion: { in: %w(south north) }
  validates :origin_time,  presence: true
  validates :number, presence: true,
                     uniqueness: true,
                     numericality: true,
                     length: { is: 3 }

  default_scope { order('origin_time') }

  def to_param
    number.to_s
  end

  def stop_for(station)
    stops.where(station: station).first
  end

  def self.find_by_param(input)
    find_by_number(input.to_i)
  end

  def schedule_type
    case number.to_s[0].to_i
    when 1, 4 then :local
    when 2 then :limited
    when 3, 8 then :bullet
    end
  end

  def weekend?
    !weekday?
  end

  def weekday?
    schedule == 'weekend'
  end

  [:south, :north].each do |dir|
    define_method "#{dir}?" do
      dir == direction
    end

    define_method "#{dir}bound?" do
      dir == direction
    end
  end
end
