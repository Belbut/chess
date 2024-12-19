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
      next if possible_position.nil?

      actual_move_nodes.append(possible_position)

      # add requirement compliment here
      # not complete only prove focus on green test
    end
    actual_move_nodes
  end

  def possible_move_nodes_factory(pattern, parent_coordinate)
    node_properties = pattern_child_properties(pattern)

    node_properties.map do |node_data|
      MovePositionNode.new(child_coordinate(node_data[:move_step], parent_coordinate),
                           node_data[:propagation_pattern],
                           node_data[:propagation_direction])
    end
  end

  def pattern_child_properties(pattern)
    node_properties = []
    case pattern
    in [Integer, Integer]
      node_properties.append({ move_step: pattern, propagation_pattern: [0, 0], propagation_direction: nil })
    in [:n, :nn] | [:nn, :n]
      node_properties.append({ move_step: [1, -1], propagation_pattern: pattern, propagation_direction: :positive })
      node_properties.append({ move_step: [-1, 1], propagation_pattern: pattern, propagation_direction: :negative })
    in [:n, int]
      node_properties.append({ move_step: [1, int], propagation_pattern: [:n, 0], propagation_direction: :positive })
      node_properties.append({ move_step: [-1, int], propagation_pattern: [:n, 0], propagation_direction: :negative })
    in [int, :n]
      node_properties.append({ move_step: [int, 1], propagation_pattern: [0, :n], propagation_direction: :positive })
      node_properties.append({ move_step: [int, -1], propagation_pattern: [0, :n], propagation_direction: :negative })
    end
    node_properties
  end

  def possible_move_nodes(parent_movement_pattern, parent_coordinate)
    possible_move_nodes = []

    parent_movement_pattern.pattern.each do |pattern|
      possible_move_nodes += possible_move_nodes_factory(pattern, parent_coordinate)
    end

    possible_move_nodes.map! do |move_node|
      move_node
    end

    possible_move_nodes
  end

  def child_coordinate(direction, parent_coordinate)
    [direction.first + parent_coordinate.x, direction.last + parent_coordinate.y]
  end
end
