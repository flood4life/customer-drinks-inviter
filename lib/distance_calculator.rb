class DistanceCalculator
  class DistanceCalculator::ArgumentError < ArgumentError
  end

  class << self
    def call(point1, point2)
      assign_input(point1, point2)
      validate_instance
      convert_instance_to_radians
      distance
    end

    private

    EARTH_RADIUS = 6_371e3 # 6371km

    def distance
      sin_product     = Math.sin(@lat1) * Math.sin(@lat2)
      longitude_delta = (@long1 - @long2).abs
      cos_product     = Math.cos(@lat1) * Math.cos(@lat2) * Math.cos(longitude_delta)
      central_angle   = Math.acos(sin_product + cos_product)
      EARTH_RADIUS * central_angle
    end

    def radians_from_degrees(degrees)
      degrees * Math::PI / 180
    end

    def convert_instance_to_radians
      @lat1  = radians_from_degrees(@lat1)
      @lat2  = radians_from_degrees(@lat2)
      @long1 = radians_from_degrees(@long1)
      @long2 = radians_from_degrees(@long2)
    end

    def assign_input(point1, point2)
      @lat1  = point1[:latitude]
      @lat2  = point2[:latitude]
      @long1 = point1[:longitude]
      @long2 = point2[:longitude]
    end

    def validate_instance
      raise_exception(1, :latitude, @lat1) unless latitude_check(@lat1)
      raise_exception(2, :latitude, @lat2) unless latitude_check(@lat2)
      raise_exception(1, :longitude, @long1) unless longitude_check(@long1)
      raise_exception(2, :longitude, @long2) unless longitude_check(@long2)
    end

    def latitude_check(latitude)
      latitude.is_a?(Numeric) && (-90...90).cover?(latitude)
    end

    def longitude_check(longitude)
      longitude.is_a?(Numeric) && (-180...180).cover?(longitude)
    end

    def raise_exception(point_index, entity, value)
      raise DistanceCalculator::ArgumentError, "Point #{point_index} has invalid #{entity} of #{value}"
    end
  end
end