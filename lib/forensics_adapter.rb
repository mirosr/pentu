require 'uri'
require 'net/http'

require 'responses/directions'
require 'responses/error'
require 'responses/result'

module ForensicsAdapter
  def self.directions
    response = get_directions

    if response_successful?(response)
      Responses::Directions.load(response.body)
    else
      Responses::Error.load(response.body)
    end
  rescue => e
    Responses::Error.general(e.message)
  end

  def self.submit_location(x:, y:)
    response = get_result(x, y)

    Responses::Result.load(response.body)
  rescue => e
    Responses::Error.general(e.message)
  end

  private

  def self.get_directions
    Net::HTTP.get_response(directions_url)
  end

  def self.get_result(x, y)
    Net::HTTP.get_response(location_url(x, y))
  end

  def self.directions_url
    URI.parse(URL).tap do |uri|
      uri.path += '/directions'
    end
  end

  def self.location_url(x, y)
    URI.parse(URL).tap do |uri|
      uri.path += "/location/#{x}/#{y}"
    end
  end

  def self.response_successful?(response)
    response.is_a?(Net::HTTPOK)
  end

  EMAIL = 'miro-test@example.com'
  # EMAIL = 'miro@mirosr.net'
  URL = "http://which-technical-exercise.herokuapp.com/api/#{EMAIL}"
end
