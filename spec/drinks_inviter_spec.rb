require_relative 'spec_helper'
require_relative '../lib/drinks_inviter'
require_relative '../lib/customer_drinks_invite_predicate'

describe DrinksInviter do
  before do
    @filename = 'customers'
    File.open(@filename, 'w') do |f|
      f.puts '{"latitude": "53.8856167", "user_id": 2, "name": "Ian McArdle", "longitude": "-6.4240951"}'
      f.puts '{"latitude": "53.8856167", "user_id": 1, "name": "Patricia Cahill", "longitude": "-6.4240951"}'
      f.puts 'not a json'
      f.puts '{"latitude": "151.8856167", "user_id": 3, "name": "Georgina Gallagher", "longitude": "-10.4240951"}'
      f.puts '{"latitude": "51.8856167", "user_id": 4, "name": "Olive Ahearn", "longitude": "-100.4240951"}'
    end
  end

  after do
    File.delete(@filename)
  end

  it 'parses a file and outputs eligible customers (based on a predicate) ordered by user_id' do
    predicate      = CustomerDrinksInvitePredicate.new(max_distance: 100e3)
    dublin_office  = { latitude: 53.339428, longitude: -6.257664 }
    drinks_inviter = DrinksInviter.new(
      predicate: predicate,
      filename:  @filename,
      center:    dublin_office
    )
    assert_output("Patricia Cahill (1)\nIan McArdle (2)\n") do
      drinks_inviter.call
    end
  end

  it 'allows to use a custom formatter' do
    predicate      = CustomerDrinksInvitePredicate.new(max_distance: 100e3)
    dublin_office  = { latitude: 53.339428, longitude: -6.257664 }
    formatter      = ->(customer) { "ID: #{customer[:user_id]}, Name: #{customer[:name]}" }
    drinks_inviter = DrinksInviter.new(
      predicate: predicate,
      filename:  @filename,
      center:    dublin_office,
      formatter: formatter
    )
    assert_output("ID: 1, Name: Patricia Cahill\nID: 2, Name: Ian McArdle\n") do
      drinks_inviter.call
    end
  end

  it 'allows to use a custom sort_by value' do
    predicate      = CustomerDrinksInvitePredicate.new(max_distance: 100e3)
    dublin_office  = { latitude: 53.339428, longitude: -6.257664 }
    sorter         = ->(customer) { -customer[:user_id] } # DESC by user_id
    drinks_inviter = DrinksInviter.new(
      predicate: predicate,
      filename:  @filename,
      center:    dublin_office,
      sorter:    sorter
    )
    assert_output("Ian McArdle (2)\nPatricia Cahill (1)\n") do
      drinks_inviter.call
    end
  end

  it 'raises an ArgumentError when a required key is not supplied' do
    dublin_office = { latitude: 53.339428, longitude: -6.257664 }
    predicate     = CustomerDrinksInvitePredicate.new(max_distance: 100e3)

    no_predicate_error = assert_raises ArgumentError do
      DrinksInviter.new(
        filename: @filename,
        center:   dublin_office
      )
    end
    assert_match(/Key :predicate is required/, no_predicate_error.message)

    no_filename_error = assert_raises ArgumentError do
      DrinksInviter.new(
        predicate: predicate,
        center:    dublin_office
      )
    end
    assert_match(/Key :filename is required/, no_filename_error.message)

    no_center_error = assert_raises ArgumentError do
      DrinksInviter.new(
        predicate: predicate,
        filename:  @filename
      )
    end
    assert_match(/Key :center is required/, no_center_error.message)
  end
end