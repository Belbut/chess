class PatternRules
  attr_reader :pattern, :requirements

  def initialize(pattern, *requirements)
    puts '-'
    @pattern = pattern # [array]
    @requirements = requirements
  end
end

module Requirement
  # require_relative '../../chess_kit/board'
  # all
  def self.inside_board(board)
    proc { |target_cord|
      board.inside_board?(target_cord)
    }
  end

  # all
  def self.no_friendly_kill; end

  # king
  def self.castle_conditions(castle_side); end

  # king
  def self.no_suicide_move; end

  # pawn
  def self.no_straight_kill; end

  # pawn
  def self.no_side_move; end

  # pawn
  def self.rush_move; end
end
