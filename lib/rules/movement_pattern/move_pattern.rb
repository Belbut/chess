class MovePattern
  attr_reader :pattern, :requirement

  def initialize(pattern, *requirement)
    @pattern = pattern
    @requirement = *requirement
  end
end

module Requirement
  # all
  def inside_board; end

  # all
  def no_friendly_kill; end

  # king
  def castle_conditions(castle_side); end

  # king
  def no_suicide_move; end

  # pawn
  def no_straight_kill; end

  # pawn
  def no_side_move; end

  # pawn
  def rush_move; end
end
