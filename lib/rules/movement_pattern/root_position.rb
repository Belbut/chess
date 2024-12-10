class RootPosition
  attr_reader :coordinate, :movement_pattern, :child_move_nodes

  def initialize(coordinate, movement_pattern)
    @coordinate = coordinate
    @movement_pattern = movement_pattern
    @child_move_nodes = create_child_move_nodes
  end

  private

  def create_child_move_nodes
    possible_move_nodes = []
    movement_pattern.pattern.each do |pattern|
      if pattern.include?(:n)
        if pattern.include?(:nn)
          possible_move_nodes.append([1, -1])
          possible_move_nodes.append([-1, 1])
        else
          positive_direction = pattern.map { |direction| direction == :n ? 1 : direction }
          negative_direction = pattern.map { |direction| direction == :n ? -1 : direction }
          possible_move_nodes.append(positive_direction, negative_direction)
        end
      else
        possible_move_nodes.append(pattern)
      end
    end
    possible_move_nodes.map! do |move_node|
      [move_node.first + coordinate.x, move_node.last + coordinate.y]
    end

    result = []
    possible_move_nodes.each do |possible_position|
      # add requirement compliment here
      # not complete only prove focus on green test
      result.append(MovePositionNode.new(possible_position, :nil, :nil))
    end
    result
  end
end
