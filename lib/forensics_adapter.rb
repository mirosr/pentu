require 'uri'
require 'net/http'
require 'responses/directions'
require 'responses/error'
require 'responses/result'

module ForensicsAdapter
  def self.directions
    response = Net::HTTP.get_response(directions_url)

    if response_successful?(response)
      Responses::Directions.load(response.body)
    else
      Responses::Error.load(response.body)
    end
  rescue => e
    Responses::Error.general(e.message)
  end

  def self.submit_location(x:, y:)
    response = Net::HTTP.get_response(directions_url)

    Responses::Result.load(response.body)
  rescue => e
    Responses::Error.general(e.message)
  end

  private

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

  EMAIL = 'miro@mirosr.net'
  URL = "http://which-technical-exercise.herokuapp.com/api/#{EMAIL}"
end
