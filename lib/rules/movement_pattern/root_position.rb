class RootPosition
  attr_reader :coordinate, :pattern_rules, :child_move_nodes

  def initialize(coordinate, pattern_rules)
    @coordinate = coordinate
    @pattern_rules = pattern_rules
    @child_move_nodes = create_child_move_nodes
  end

  private

  def create_child_move_nodes
    possible_move_nodes(pattern_rules, coordinate)
  end

  def possible_move_nodes(pattern_rules, parent_coordinate)
    possible_move_nodes = []
    requirements = pattern_rules.requirements # is a array with lambdas of the requirement condition

    pattern_rules.pattern.each do |pattern|
      possible_move_nodes += possible_move_nodes_factory(pattern, requirements, parent_coordinate)
    end

    possible_move_nodes
  end

  def possible_move_nodes_factory(pattern, requirements, parent_coordinate)
    node_properties = pattern_child_properties(pattern)

    possible_nodes = node_properties.filter do |single_node_property|
      target_coordinate = child_coordinate(single_node_property[:move_step], parent_coordinate)
      comply_with_restrictions(target_coordinate, requirements)
    end

    possible_nodes.map do |node_data|
      MovePositionNode.new(child_coordinate(node_data[:move_step], parent_coordinate),
                           node_data[:propagation_pattern],
                           node_data[:propagation_moment])
    end
  end

  def comply_with_restrictions(target_coordinate, requirements)
    requirements.all? { |individual_requirement| individual_requirement.call(target_coordinate) == true }
  end

  def pattern_child_properties(pattern)
    node_properties = []
    case pattern
    in [Integer, Integer]
      node_properties.append({ move_step: pattern, propagation_pattern: [0, 0], propagation_moment: nil })
    in [:n, :nn] | [:nn, :n]
      node_properties.append({ move_step: [1, -1], propagation_pattern: pattern, propagation_moment: :positive })
      node_properties.append({ move_step: [-1, 1], propagation_pattern: pattern, propagation_moment: :negative })
    in [:n, :n] | [:nn, :nn]
      node_properties.append({ move_step: [1, 1], propagation_pattern: pattern, propagation_moment: :positive })
      node_properties.append({ move_step: [-1, -1], propagation_pattern: pattern, propagation_moment: :negative })
    in [:n, int]
      node_properties.append({ move_step: [1, int], propagation_pattern: [:n, 0], propagation_moment: :positive })
      node_properties.append({ move_step: [-1, int], propagation_pattern: [:n, 0], propagation_moment: :negative })
    in [int, :n]
      node_properties.append({ move_step: [int, 1], propagation_pattern: [0, :n], propagation_moment: :positive })
      node_properties.append({ move_step: [int, -1], propagation_pattern: [0, :n], propagation_moment: :negative })
    end
    node_properties
  end

  def child_coordinate(direction, parent_coordinate)
    [direction.first + parent_coordinate.x, direction.last + parent_coordinate.y]
  end
end
