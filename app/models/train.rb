# Class to manage Train information
class Train < ActiveRecord::Base
  has_many :stops, dependent: :destroy
  has_many :stations, through: :stops

  #validates :schedule, presence: true,
  #                    inclusion: { in: %w(weekday weekend) }
  validates :direction, presence: true,
                        inclusion: { in: %w(south north) }
  validates :origin_time,  presence: true
  validates :number, presence: true,
                     uniqueness: true,
                     numericality: true,
                     length: { is: 3 }

  after_create :assign_schedule

  default_scope { order('origin_time') }

  def to_param
    number.to_s
  end

  def self.find_by_param(input)
    find_by_number(input.to_i)
  end

  def stop_for(station)
    fail unless station.is_a?(Station)
    stops.where(station: station).first
  end

  def schedule_type
    case number.to_s[0].to_i
    when 1, 4 then :local
    when 2 then :limited
    when 3, 8 then :bullet
    else fail 'Invalid train number detected'
    end
  end

  def weekend?
    !weekday?
  end

  def weekday?
    schedule == 'weekday'
  end

  [:south, :north].each do |dir|
    define_method "#{dir}?" do
      dir == direction
    end

    define_method "#{dir}bound?" do
      dir == direction
    end
  end

  def self.traveling_between(origin, destination, schedule)
    origin = Station.find_by_param(origin) unless origin.is_a?(Station)
    destination = Station.find_by_param(destination) unless destination.is_a?(Station)

    if origin.present? && destination.present?
      trains = (origin.trains.where(schedule: schedule) & destination.trains.where(schedule: schedule))
      travel_dir = origin.sequence < destination.sequence ? 'south' : 'north'
      trains.delete_if { |train| train.direction != travel_dir }
      trains
    end
  end

  private

  def assign_schedule
    update_attribute(:schedule, [4, 8].include?(number.to_s[0].to_i) ? 'weekend' : 'weekday')
  end
end
