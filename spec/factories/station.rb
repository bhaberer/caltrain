FactoryGirl.define do
  factory :station do
    name 'Station Location'
    add_attribute :sequence, 0
    zone 1
    uid 'station_location'
  end
end
