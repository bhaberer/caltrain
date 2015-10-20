FactoryGirl.define do
  factory :train do
    number { rand(900) + 99 }
    direction 'north'
    origin_time Time.now
  end
end
