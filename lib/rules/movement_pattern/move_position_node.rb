class MovePositionNode
  attr_reader :coordinate, :node_move_pattern, :direction

  def initialize(coordinate, node_move_pattern, direction = nil)
    @coordinate = coordinate
    @node_move_pattern = node_move_pattern
    @direction = direction
  end
end
