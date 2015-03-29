require 'spec_helper'

describe Drone do
  let(:described_entity) { Drone.new(x: 0, y: 0) }

  it 'flys to a specific location by following the given directions' do
    described_entity.fly(directions)

    described_entity.location.must_equal expected_location
  end

  context 'when no directions are given' do
    it 'keeps its current possition' do
      described_entity.fly([])

      described_entity.location.must_equal start_location
    end
  end

  context 'when an invalid direction is given' do
    it 'stops at its last good location' do
      begin
        described_entity.fly(['forward', 'reverse'])
      rescue
      ensure
        described_entity.location.must_equal last_good_location
      end
    end

    it 'raises an error' do
      proc {
        described_entity.fly(['forward', 'reverse'])
      }.must_raise ArgumentError, %q(Invalid direction 'reverse')
    end
  end

  private

  def start_location
    Location.new(0, 0)
  end

  def directions
    [
      'forward',
      'right',
      'forward',
      'right',
      'forward',
      'left',
      'forward',
      'left',
      'forward',
      'forward',
      'right',
      'forward'
    ]
  end

  def expected_location
    Location.new(3, 2)
  end

  def last_good_location
    Location.new(0, 1)
  end
end
