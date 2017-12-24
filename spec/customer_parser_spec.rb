require 'minitest/autorun'
require_relative '../src/customer_parser'

describe CustomerParser do
  describe 'when input is a valid JSON' do
    it 'disregards any unknown keys' do
      input = <<-JSON
        {"user_id": 1, "name": "Alex", "unknown_key": 2}
      JSON
      parsed = CustomerParser.call(input)
      assert_empty parsed[:unknown_key]
      assert_empty parsed['unknown_key']
      assert_equal 1, parsed[:user_id]
      assert_equal 'Alex', parsed[:name]
    end

    it 'converts latitude and longitude to floats' do
      input = <<-JSON
        {"latitude": "1", "longitude": "2"}
      JSON
      parsed = CustomerParser.call(input)
      assert_in_epsilon 1.0, parsed[:latitude]
      assert_in_epsilon 2.0, parsed[:longitude]
    end
  end

  describe 'when input is not a valid JSON' do
    it 'raises an ArgumentError' do
      input = 'really not a JSON'
      assert_raises ArgumentError do
        CustomerParser.call(input)
      end
    end
  end
end