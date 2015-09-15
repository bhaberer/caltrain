class Stop < ActiveRecord::Base
  belongs_to :train
  belongs_to :station
  delegate :number, to: :train, prefix: true
  delegate :name, to: :station, prefix: true

  validates :train, presence: true
  validates :station, presence: true
  validates :time, presence: true
  validates :direction, presence: true,
                        inclusion: { in: %w(south north) }

  def by_schedule
    order_by(:time)
  end

  def display_time
    time.strftime('%l:%M%P')
  end
end
