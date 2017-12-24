require 'minitest/autorun'
require_relative '../src/customer_drinks_invite_predicate'

describe CustomerDrinksInvitePredicate do
  describe 'when maximum distance is negative' do
    it 'raises an ArgumentError' do
      assert_raises ArgumentError do
        CustomerDrinksInvitePredicate.new(max_distance: -1)
      end
    end
  end

  describe 'when distance is less or equal than the maximum distance' do
    it 'returns true' do
      predicate = CustomerDrinksInvitePredicate.new(max_distance: 200e3)
      assert_equal true, predicate.call(50)
      assert_equal true, predicate.call(50e3)
      assert_equal true, predicate.call(200e3)
    end
  end

  describe 'when distance is greater than the maximum distance' do
    it 'returns false' do
      predicate = CustomerDrinksInvitePredicate.new(max_distance: 200e3)
      assert_equal false, predicate.call(200e3 + 1)
      assert_equal false, predicate.call(Float::INFINITY)
    end
  end
end