FactoryGirl.define do
  factory :stop do
    time Time.now
    direction 'north'
    train
    station
  end
end
