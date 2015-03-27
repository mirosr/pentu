require 'json'

module ForensicsAdapter
  def self.directions
    uri = URI.parse('')

    response = Net::HTTP.get_response(uri)

    JSON.parse(response.body)
  end

  def self.submit_location(x:, y:)
  end
end
