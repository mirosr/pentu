require 'singleton'

require 'forensics_adapter'
require 'drone'
require 'responses/directions'
require 'responses/error'
require 'responses/result'

class Application
  include Singleton

  def self.run
    instance.public_send(__method__)
  end

  def run
    response = nil
    say 'Quering forensics web service for directions' do
      response = ForensicsAdapter.directions
    end

    if response.error?
      say 'No drones were sent since the forensics web service returned an error:', false
      puts "\n#{response.error}\n\n"
      say 'No kittens were saved!!! :(', false
    else
      say 'Sending a drone to follow the forensics directions' do
        drone.fly(response.value)
      end
      say %{Drone's last location (x,y): #{drone.x},#{drone.y}}, false

      say %q(Sending drone's last location to the forensics web service) do
        response = ForensicsAdapter.submit_location(
          x: drone.x, y: drone.y)
      end

      say response.value, false
    end
  end

  private

  def drone
    @drone ||= Drone.new(x: 0, y: 0)
  end

  def say(message, with_acknowledge = true)
    message = '=^.^= ' + message.to_s

    if with_acknowledge
      message += '...' if with_acknowledge
      print message
    else
      puts message
    end

    yield if block_given?

    puts ' done!' if with_acknowledge
  end
end
