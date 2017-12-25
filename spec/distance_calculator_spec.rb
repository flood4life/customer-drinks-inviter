require 'minitest/autorun'
require_relative '../src/distance_calculator'

describe DistanceCalculator do
  describe 'when input is correct' do
    it 'returns zero if both points are the same' do
      point = { latitude: 10, longitude: 10 }
      assert_in_delta 0, DistanceCalculator.call(point, point), 0.1 # use delta here because relative error makes no sense for 0
    end

    it 'returns correct distance between Moscow and Dublin' do
      # data from WolframAlpha
      moscow   = { latitude: 55.75, longitude: -37.62 }
      dublin   = { latitude: 53.33, longitude: 6.25 }
      distance = 2804e3 # 2804km
      assert_in_epsilon distance, DistanceCalculator.call(moscow, dublin), 0.01
    end

    it 'returns correct distance between London and Dublin' do
      # data from WolframAlpha
      london   = { latitude: 51.5, longitude: 0.1167 }
      dublin   = { latitude: 53.33, longitude: 6.25 }
      distance = 464.1e3 # 464.1km
      assert_in_epsilon distance, DistanceCalculator.call(london, dublin), 0.01
    end
  end

  describe 'when input is incorrect' do
    it 'raises a DistanceCalculator::ArgumentError' do
      assert_raises DistanceCalculator::ArgumentError do
        latitude_out_of_bounds = { latitude: 100, longitude: 10 }
        DistanceCalculator.call(latitude_out_of_bounds, latitude_out_of_bounds)
      end
      assert_raises DistanceCalculator::ArgumentError do
        longitude_out_of_bounds = { latitude: 10, longitude: 200 }
        DistanceCalculator.call(longitude_out_of_bounds, longitude_out_of_bounds)
      end
      assert_raises DistanceCalculator::ArgumentError do
        missing_longitude = { latitude: 10 }
        DistanceCalculator.call(missing_longitude, missing_longitude)
      end
      assert_raises DistanceCalculator::ArgumentError do
        missing_latitude = { longitude: 10 }
        DistanceCalculator.call(missing_latitude, missing_latitude)
      end
    end
  end

end