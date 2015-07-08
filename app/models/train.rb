# Class to manage Train information
class Train < ActiveRecord::Base
  has_many :stops, dependent: :destroy

  validates :number, presence: :true,
                     numericality: true,
                     length: { is: 3 }

  def schedule_type
    case number.to_s[0].to_i
    when 1, 4 then :local
    when 2 then :limited
    when 3, 8 then :bullet
    end
  end

  def direction
    number.even? ? :southbound : :northbound
  end
end
