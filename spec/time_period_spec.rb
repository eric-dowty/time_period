require 'rspec'
require_relative '../lib/time_period'

describe TimePeriod do
  let(:start_epoch) { 1535391265 }
  let(:finish_epoch) { 1535391865 }

  describe 'validation' do
    it 'should throw and error if finish is before start' do
      expect { TimePeriod.new(start_epoch,start_epoch-10) }.to raise_error(InvalidTimePeriod, 'finish time must be after start time')
    end

    it 'should throw and error if finish is same as start' do
      expect { TimePeriod.new(start_epoch,start_epoch) }.to raise_error(InvalidTimePeriod, 'finish time must be after start time')
    end
  end

  describe '#start' do
    it 'should return the start time' do
      expect(TimePeriod.new(start_epoch,finish_epoch).start).to eq(start_epoch)
    end
  end

  describe '#finish' do
    it 'should return the finish time' do
      expect(TimePeriod.new(start_epoch,finish_epoch).finish).to eq(finish_epoch)
    end
  end

  describe '#intersection' do
    it 'should return empty intersection if intersecting time period ends before time period starts' do
      intersecting_time_period = TimePeriod.new(start_epoch-100, start_epoch-10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([])
    end

    it 'should return empty intersection if intersecting time period starts after time period ends' do
      intersecting_time_period = TimePeriod.new(finish_epoch+10, finish_epoch+100)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([])
    end

    it 'should return start_epoch and finish_epoch if intersecting time period overlaps' do
      intersecting_time_period = TimePeriod.new(start_epoch-10, finish_epoch+10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([start_epoch, finish_epoch])
    end

    it 'should return start and end of intersecting time period if it is contained within the time period' do
      intersecting_time_period = TimePeriod.new(start_epoch+10, finish_epoch-10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([start_epoch+10, finish_epoch-10])
    end

    it 'should return start and end of intersecting time period if it starts and ends at the same time' do
      intersecting_time_period = TimePeriod.new(start_epoch, finish_epoch)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([start_epoch, finish_epoch])
    end

    it 'should return the start of the time period and end of the intersecting time period if it ends after the time period start' do
      intersecting_time_period = TimePeriod.new(start_epoch-10, start_epoch+10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([start_epoch, start_epoch+10])
    end

    it 'should return the start of the time period and end of the intersecting time period if it ends after the time period start and starts at the same time' do
      intersecting_time_period = TimePeriod.new(start_epoch, start_epoch+10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([start_epoch, start_epoch+10])
    end

    it 'should return the start of the intersecting time period and end of the time period if it starts before the time period finish' do
      intersecting_time_period = TimePeriod.new(finish_epoch-10, finish_epoch+10)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([finish_epoch-10, finish_epoch])
    end

    it 'should return the start of the intersecting time period and end of the time period if it starts before the time period finish and ends at the same time' do
      intersecting_time_period = TimePeriod.new(finish_epoch-10, finish_epoch)

      expect(TimePeriod.new(start_epoch,finish_epoch).intersection(intersecting_time_period)).to eq([finish_epoch-10, finish_epoch])
    end
  end
end

