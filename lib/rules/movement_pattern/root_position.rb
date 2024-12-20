require_relative './movement_util'
class RootPosition
  attr_reader :coordinate, :pattern_rules, :child_move_nodes

  include MovementUtil

  def initialize(coordinate, pattern_rules)
    @coordinate = coordinate
    @pattern_rules = pattern_rules
    @child_move_nodes = multidirectional_child_move_nodes(coordinate, pattern_rules)
  end

  private
  
  def multidirectional_child_move_nodes(coordinate, pattern_rules)
    possible_move_nodes = []
    requirements = pattern_rules.requirements # is a array with lambdas of the requirement condition

    pattern_rules.pattern.each do |pattern|
      possible_move_nodes += MovementUtil.possible_move_nodes_factory(pattern, requirements, coordinate)
    end

    possible_move_nodes
  end
end
