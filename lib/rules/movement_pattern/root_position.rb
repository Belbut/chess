class RootPosition
  attr_reader :coordinate, :movement_pattern, :child_move_nodes

  def initialize(coordinate, movement_pattern)
    @coordinate = coordinate
    @movement_pattern = movement_pattern
    @child_move_nodes = create_child_move_nodes
  end

  private

  def create_child_move_nodes
    possible_move_nodes = possible_move_nodes(movement_pattern, coordinate)

    actual_move_nodes = []
    possible_move_nodes.each do |possible_position|
      # add requirement compliment here
      # not complete only prove focus on green test
      actual_move_nodes.append(MovePositionNode.new(possible_position, :nil, :nil))
    end
    actual_move_nodes
  end

  def pattern_matching(pattern)
    case pattern
    in [0, 0]
      nil
    in [Integer, Integer]
      pattern
    in [:nn, :n]|[:n, :nn]
      [[1, -1], [-1, 1]]
    in [:n, int]
      [[1, int], [-1, int]]
    in [int, :n]
      [[int, 1], [int, -1]]
    end
  end

  def possible_move_nodes(parent_movement_pattern, parent_coordinate)
    possible_move_nodes = []

    parent_movement_pattern.pattern.each do |pattern|
      possible_move_nodes += pattern_matching(pattern)
    end

    possible_move_nodes.map! do |move_node|
      [move_node.first + parent_coordinate.x, move_node.last + parent_coordinate.y]
    end

    possible_move_nodes
  end
end
