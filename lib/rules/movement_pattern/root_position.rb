require_relative './movement_util'
require_relative './pattern_rules'
class RootPosition
  attr_reader :coordinate, :pattern_rules, :child_move_nodes

  include MovementUtil

  def initialize(coordinate, pattern_rules)
    @coordinate = coordinate
    @pattern_rules = pattern_rules
    @child_move_nodes = multidirectional_child_move_nodes(coordinate, pattern_rules)
  end

  def find_all_paths
    child_move_nodes.map(&:traverse_path)
  end

  private

  def multidirectional_child_move_nodes(parent_coordinate, pattern_rules)
    possible_move_nodes = []
    requirements = pattern_rules.requirements # is a array with lambdas of the requirement condition

    pattern_rules.pattern.each do |pattern|
      possible_move_nodes += RootPosition.possible_move_nodes_factory(pattern, requirements, parent_coordinate)
    end

    possible_move_nodes
  end

  def self.possible_move_nodes_factory(pattern, requirements, parent_coordinate)
    next_node_properties = RootPosition.pattern_child_properties(pattern)

    possible_nodes = next_node_properties.filter do |single_node_property|
      target_coordinate = MovementUtil.child_coordinate(single_node_property[:move_step], parent_coordinate)
      MovementUtil.comply_with_restrictions(parent_coordinate, target_coordinate, requirements)
    end

    possible_nodes.map do |node_data|
      MovePositionNode.new(MovementUtil.child_coordinate(node_data[:move_step], parent_coordinate),
                           (node_data[:propagation_pattern]),
                           requirements,
                           node_data[:propagation_inertia])
    end
  end

  def self.pattern_child_properties(pattern)
    next_node_properties = []
    case pattern
    in [Integer, Integer]
      next_node_properties.append({ move_step: pattern, propagation_pattern: [0, 0], propagation_inertia: nil })
    in [:n, :nn] | [:nn, :n]
      next_node_properties.append({ move_step: [1, -1], propagation_pattern: pattern, propagation_inertia: :positive })
      next_node_properties.append({ move_step: [-1, 1], propagation_pattern: pattern, propagation_inertia: :negative })
    in [:n, :n] | [:nn, :nn]
      next_node_properties.append({ move_step: [1, 1], propagation_pattern: pattern, propagation_inertia: :positive })
      next_node_properties.append({ move_step: [-1, -1], propagation_pattern: pattern, propagation_inertia: :negative })
    in [:n, int]
      next_node_properties.append({ move_step: [1, int], propagation_pattern: [:n, 0], propagation_inertia: :positive })
      next_node_properties.append({ move_step: [-1, int], propagation_pattern: [:n, 0],
                                    propagation_inertia: :negative })
    in [int, :n]
      next_node_properties.append({ move_step: [int, 1], propagation_pattern: [0, :n], propagation_inertia: :positive })
      next_node_properties.append({ move_step: [int, -1], propagation_pattern: [0, :n],
                                    propagation_inertia: :negative })
    end
    next_node_properties
  end
end
