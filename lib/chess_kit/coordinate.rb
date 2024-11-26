class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.from_array(array_position)
    raise ArgumentError, 'Array must have exactly two elements' unless array_position.size == 2

    x, y = array_position

    new(x, y)
  end
end
