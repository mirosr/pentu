require 'singleton'

class Application
  include Singleton

  def self.run
    instance.public_send(__method__)
  end

  def run
    directions = []
    say 'Quering forensics web service for directions' do
      directions = ForensicsAdapter.directions
    end

    say 'Sending a drone to follow the forensics directions' do
      drone.fly(directions)
    end
    say(%{Drone's last location (x,y): #{drone.x},#{drone.y}}, false)

    search_party_message = ''
    say %q(Sending drone's last location to the forensics web service) do
      search_party_message = ForensicsAdapter.submit_location(
        x: drone.x, y: drone.y)
    end

    say(search_party_message, false)
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
