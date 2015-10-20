require 'rails_helper'

RSpec.describe Train, type: :model do
  let(:train) { create(:train) }

  describe 'validations' do
    context 'when validating origin_time' do
      it 'has presence' do
        expect(build(:train, origin_time: nil)).not_to be_valid
      end
    end

    context 'when validating schedule' do
      it 'has presence' do
        expect(build(:train, schedule: nil)).not_to be_valid
      end

      it 'has allowed content' do
        expect(build(:train, schedule: 'fooba')).not_to be_valid
        expect(build(:train, schedule: 1231221)).not_to be_valid
        expect(build(:train, schedule: 'weekend')).to be_valid
        expect(build(:train, schedule: 'weekday')).to be_valid
      end
    end

    context 'when validating number' do
      it 'has numericality' do
        expect(build(:train, number: 'foo')).not_to be_valid
      end

      it 'has uniqueness' do
        create(:train, number: 101)
        expect(build(:train, number: 101)).not_to be_valid
      end

      it 'has presence' do
        expect(build(:train, number: nil)).not_to be_valid
      end

      it 'has proper length' do
        expect(build(:train, number: 22)).not_to be_valid
        expect(build(:train, number: 2222)).not_to be_valid
      end
    end

    context 'when validating direction' do
      it 'has presence' do
        expect(build(:train, direction: nil)).not_to be_valid
      end

      it 'has allowed content' do
        expect(build(:train, direction: 'fooba')).not_to be_valid
        expect(build(:train, direction: 1231221)).not_to be_valid
        expect(build(:train, direction: 'south')).to be_valid
        expect(build(:train, direction: 'north')).to be_valid
      end
    end
  end

  describe '.to_param' do
    it 'returns the string version of the number' do
      expect(train.number.to_s).to eq(train.to_param)
    end

    it 'is a String' do
      expect(train.to_param).to be_a(String)
    end
  end

describe '.find_by_param' do
  it 'returns a train' do
    create(:train, number: 101)
    expect(Train.find_by_param('101')).to be_a(Train)
  end

  it 'returns the train with the corresponding number' do
    train = create(:train, number: 101)
    expect(Train.find_by_param('101')).to eq(train)
  end

  it 'returns the same train for a string or an int' do
    create(:train, number: 101)
    expect(Train.find_by_param('101')).to eq(Train.find_by_param(101))
  end

  it 'returns nil for a train number that does not exist' do
    expect(Train.find_by_param('999')).to be_nil
  end

  it 'returns nil for a string that is not to_int\'able' do
    expect(Train.find_by_param('Foo')).to be_nil
  end

  describe '.schedule_type' do
    [[:local, 1], [:local, 4], [:limited, 2], [:bullet, 3], [:bullet, 8]].each do |sched, number|
      it "returns #{sched} for #{sched} trains starting with #{number}" do
        train = create(:train, number: number * 100)
        expect(train.schedule_type).to eq(sched)
      end
    end

    it 'raises if the number is not valid' do
      train = create(:train, number: 900)
      expect{ train.schedule_type }.to raise_exception
    end
  end
end


  describe '.stop_for' do
    it 'returns nil if no stops exist' do
      train = create(:train)
      station = create(:station, name: 'Palo Alto')
      expect(train.stop_for(station)).to be_nil
    end

    it 'returns nil if no appropriate stop exists' do
      train = create(:train)
      station1 = create(:station, name: 'Palo Alto')
      create(:stop, train: train, station: station1)
      station2 = create(:station, name: 'California')
      create(:stop, train: train, station: station2)
      station3 = create(:station, name: 'Redwood')

      expect(train.stop_for(station3)).to be_nil
    end

    it 'raises if a Station isn\'t passed.' do
      expect{ train.stop_for([]) }.to raise_exception
    end

    it 'returns a Stop' do
        train = create(:train)
        station = create(:station, name: 'Palo Alto')
        create(:stop, train: train, station: station)

        expect(train.stop_for(station)).to be_a(Stop)
    end

    it 'returns the correct Stop' do
      train = create(:train)
      station = create(:station, name: 'Palo Alto')
      stop = create(:stop, train: train, station: station)
      create(:stop, train: train, station: create(:station, name: 'California'))
      create(:stop, train: train, station: create(:station, name: 'Redwood'))

      expect(train.stop_for(station)).to eq(stop)
    end
  end

  describe '.weekend?' do
    it 'should return true for 8** trains' do
      expect(create(:train, number: 800).weekend?).to eq(true)
    end

    it 'should return true for 4** trains' do
      expect(create(:train, number: 400).weekend?).to eq(true)
    end

    it 'should return false for 1** trains' do
      expect(create(:train, number: 100).weekend?).to eq(false)
    end

    it 'should return false for 2** trains' do
      expect(create(:train, number: 200).weekend?).to eq(false)
    end

    it 'should return false for 3** trains' do
      expect(create(:train, number: 400).weekend?).to eq(false)
    end
  end

end
