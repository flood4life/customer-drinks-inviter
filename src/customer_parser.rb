require 'json'

class CustomerParser
  class CustomerParser::ParseError < ArgumentError
  end

  def self.call(json_string)
    parsed_json = JSON.parse(json_string)
    # using safe operator &. because CustomerValidator will take care if it's nil
    {
      name:      parsed_json['name'],
      user_id:   parsed_json['user_id']&.to_i,
      latitude:  parsed_json['latitude']&.to_f,
      longitude: parsed_json['longitude']&.to_f
    }
  rescue JSON::ParserError => _e
    raise CustomerParser::ParseError, "Not a valid json: #{json_string}"
  end
end