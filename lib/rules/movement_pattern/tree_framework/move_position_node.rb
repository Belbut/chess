require_relative '../movement_util'

class MovePositionNode
  attr_reader :coordinate, :pattern, :propagation_inertia, :child_move_node

  def initialize(coordinate, pattern, requirements, propagation_inertia)
    @coordinate = coordinate
    @pattern = pattern
    @requirements = requirements
    @propagation_inertia = propagation_inertia
    @child_move_node = one_direction_child_move_node(coordinate, pattern, requirements, propagation_inertia)
  end

  def traverse_path
    if child_move_node.nil?
      [coordinate]
    else
      [coordinate] + child_move_node.traverse_path
    end
  end

  private

  def one_direction_child_move_node(parent_coordinate, pattern, requirements, propagation_inertia)
    return nil if propagation_inertia.nil? || pattern == [0, 0]

    possible_move_node_factory(parent_coordinate, pattern, requirements, propagation_inertia)
  end

  def possible_move_node_factory(parent_coordinate, pattern, requirements, propagation_inertia)
    next_step = transform_pattern_to_step(pattern, propagation_inertia)
    target_coordinate = MovementUtil.child_coordinate(next_step, parent_coordinate)

    return nil unless MovementUtil.comply_with_restrictions(parent_coordinate, target_coordinate, requirements)

    MovePositionNode.new(target_coordinate, pattern, requirements, propagation_inertia)
  end

  NEXT_STEP = { positive: { n: 1, nn: -1 }, negative: { n: -1, nn: 1 } }.freeze

  def transform_pattern_to_step(pattern, propagation_inertia)
    pattern.map do |e|
      NEXT_STEP.dig(propagation_inertia, e) || e
    end
  end
end
