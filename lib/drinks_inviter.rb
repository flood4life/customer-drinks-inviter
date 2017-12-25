require_relative 'file_reader'
require_relative 'distance_calculator'
require_relative 'customer_validator'
require_relative 'customer_parser'

class DrinksInviter
  def initialize(**options)
    %i[filename predicate center].each do |key|
      raise ArgumentError, "Key #{key} is required" unless options[key]
    end
    @file_reader = FileReader.new(options[:filename])
    @predicate   = options[:predicate]
    @center      = options[:center]
    @formatter   = options[:formatter] || default_formatter
    @sorter      = options[:sorter] || default_sorter
  end

  def call
    eligible_customers = []
    @file_reader.each_line do |line|
      begin
        customer = CustomerParser.call(line)
        next unless CustomerValidator.call(customer)
        distance = DistanceCalculator.call(@center, customer)
      rescue DistanceCalculator::ArgumentError, CustomerParser::ParseError => _e
        next
      end
      eligible_customers << customer if @predicate.call(distance)
    end
    @file_reader.close
    sorted_and_formatted_list = eligible_customers
                                  .sort_by { |customer| @sorter.call(customer) }
                                  .map { |customer| @formatter.call(customer) }
    puts sorted_and_formatted_list
  end

  private

  def default_formatter
    ->(customer) { "#{customer[:name]} (#{customer[:user_id]})" }
  end

  def default_sorter
    ->(customer) { customer[:user_id] }
  end
end
