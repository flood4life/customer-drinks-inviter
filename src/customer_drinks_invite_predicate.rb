class CustomerDrinksInvitePredicate
  def initialize(**options)
    @max_distance = options[:max_distance]
    raise_exception(:max_distance, @max_distance) unless check_entity(@max_distance)
  end

  def call(distance)
    raise_exception(:distance, distance) unless check_entity(distance)
    distance <= @max_distance
  end

  private

  def check_entity(value)
    value.is_a?(Numeric) && value >= 0
  end

  def raise_exception(entity, value)
    raise ArgumentError, "#{entity} should be a non-negative number, got #{value}:#{value.class}"
  end
end