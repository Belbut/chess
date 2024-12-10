class MovePositionNode
  attr_reader :coordinate, :parent_move_pattern, :direction

  def initialize(coordinate, parent_move_pattern, direction)
    @coordinate = coordinate
    @parent_move_pattern = parent_move_pattern
    @direction = direction
  end
end
