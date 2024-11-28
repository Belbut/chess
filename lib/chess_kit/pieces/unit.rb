class Unit
  require_relative '../../rules/move_patterns'

  attr_reader :color, :type, :move_pattern, :capture_pattern, :move_status

  def initialize(color, type)
    @color = color
    @type = type
    @move_pattern = MovePattern::MOVE_FACTORY[type]
    @capture_pattern = @move_pattern
    @move_status = :unmoved
  end

  def mark_as_moved
    @move_status = :moved
  end

  def black?
    @color == :black
  end

  def white?
    @color == :white
  end
end
