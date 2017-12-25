require_relative 'spec_helper'
require_relative '../lib/customer_validator'

describe CustomerValidator do
  describe 'when supplied a valid customer' do
    it 'accepts when latitude, longitude, user id and name are present and valid' do
      valid_customer = { latitude: 51.92893, user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
      assert_equal true, CustomerValidator.call(valid_customer)
    end

    it 'accepts when latitude is +/- 90 and/or longitude is +/- 180' do
      valid_customer = { latitude: 90, user_id: 1, name: "Alice Cahill", longitude: -180 }
      assert_equal true, CustomerValidator.call(valid_customer)
    end
  end
  describe 'when supplied an invalid customer' do
    describe 'when latitude is invalid' do
      it 'rejects when latitude is missing' do
        missing_latitude = { user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(missing_latitude)
      end

      it 'rejects when latitude is not a number' do
        string_latitude = { latitude: "51.92893", user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
        array_latitude = { latitude: [51.92893], user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(string_latitude)
        assert_equal false, CustomerValidator.call(array_latitude)
      end

      it 'rejects when latitude is greater than 90' do
        too_much = { latitude: 90.1, user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(too_much)
      end

      it 'rejects when latitude is less than -90' do
        too_much = { latitude: -90.1, user_id: 1, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(too_much)
      end
    end

    describe 'when longitude is invalid' do
      it 'rejects when longitude is missing' do
        missing_longitude = { latitude: 51.92893, user_id: 1, name: "Alice Cahill" }
        assert_equal false, CustomerValidator.call(missing_longitude)
      end

      it 'rejects when longitude is not a number' do
        string_longitude = { latitude: 51.92893, user_id: 1, name: "Alice Cahill", longitude: "-10.27699" }
        array_longitude = { latitude: 51.92893, user_id: 1, name: "Alice Cahill", longitude: [-10.27699] }
        assert_equal false, CustomerValidator.call(string_longitude)
        assert_equal false, CustomerValidator.call(array_longitude)
      end

      it 'rejects when longitude is greater than 180' do
        too_much = { latitude: 51.92893, user_id: 1, name: "Alice Cahill", longitude: 180.1 }
        assert_equal false, CustomerValidator.call(too_much)
      end

      it 'rejects when longitude is less than -180' do
        too_much = { latitude: 51.92893, user_id: 1, name: "Alice Cahill", longitude: -180.1 }
        assert_equal false, CustomerValidator.call(too_much)
      end
    end

    describe 'when user id is invalid' do
      it 'rejects when user id is missing' do
        missing_user_id = { latitude: 51.92893, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(missing_user_id)
      end

      it 'rejects when user id is not a number' do
        string_user_id = { latitude: 51.92893, user_id: "1", name: "Alice Cahill", longitude: -10.27699 }
        array_user_id = { latitude: 51.92893, user_id: [1], name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(string_user_id)
        assert_equal false, CustomerValidator.call(array_user_id)
      end

      it 'rejects when user id is less or equal than 0' do
        zero_user_id = { latitude: 51.92893, user_id: 0, name: "Alice Cahill", longitude: -10.27699 }
        negative_user_id = { latitude: 51.92893, user_id: -1, name: "Alice Cahill", longitude: -10.27699 }
        assert_equal false, CustomerValidator.call(zero_user_id)
        assert_equal false, CustomerValidator.call(negative_user_id)
      end
    end

    describe 'when name is invalid' do
      it 'rejects when name is missing' do
        missing_name = { latitude: "51.92893", user_id: 1, longitude: "-10.27699" }
        assert_equal false, CustomerValidator.call(missing_name)
      end
    end
  end
end