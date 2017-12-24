require 'minitest/autorun'

describe DistanceCalculator do
  describe 'when input is correct' do
    it 'returns zero if both points are the same' do
      point = { latitude: 10, longitude: 10 }
      assert_in_epsilon 0, DistanceCalculator.call(point, point)
    end

    it 'returns correct distance between Moscow and Dublin' do
      # data from WolframAlpha
      moscow   = { latitude: 55.75, longitude: 37.62 }
      dublin   = { latitude: 53.33, longitude: 6.25 }
      distance = 2804e3 # 2804km
      assert_in_epsilon distance, DistanceCalculator.call(moscow, dublin)
    end
  end

  describe 'when input is incorrect' do
    it 'raises an ArgumentError' do
      assert_raises ArgumentError do
        latitude_out_of_bounds = { latitude: 100, longitude: 10 }
        DistanceCalculator.call(latitude_out_of_bounds, latitude_out_of_bounds)
      end
      assert_raises ArgumentError do
        longitude_out_of_bounds = { latitude: 10, longitude: 200 }
        DistanceCalculator.call(longitude_out_of_bounds, longitude_out_of_bounds)
      end
      assert_raises ArgumentError do
        missing_longitude = { latitude: 10 }
        DistanceCalculator.call(missing_longitude, missing_longitude)
      end
      assert_raises ArgumentError do
        missing_latitude = { longitude: 10 }
        DistanceCalculator.call(missing_latitude, missing_latitude)
      end
    end
  end

end