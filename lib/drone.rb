Location = Struct.new(:x, :y) do
  def to_s
    "#{x},#{y}"
  end
end

class Drone
  attr_reader :location

  def initialize(x:, y:)
    @heading = :north
    @location = Location.new(x, y)
  end

  def fly(directions)
    directions.each do |direction|
      validate_direction!(direction)

      if direction == 'forward'
        move_forward
      else
        check_compass(direction)
      end
    end
  end

  private

  MAPPING = {
    north: {
      left: :west,
      right: :east},
    east: {
      left: :north,
      right: :south},
    west: {
      left: :south,
      right: :north},
    south: {
      left: :east,
      right: :west}}

  def check_compass(direction)
    @heading = MAPPING[@heading][direction.to_sym]
  end

  def move_forward
    case @heading
    when :north
      @location.y += 1
    when :east
      @location.x += 1
    when :west
      @location.x -= 1
    when :south
      @location.y -= 1
    end
  end

  def validate_direction!(direction)
    unless ['forward', 'right', 'left'].include?(direction)
      raise ArgumentError, "Invalid direction '#{direction}'"
    end
  end
end
