require_relative './rules/movement'
require_relative './rules/state_conditions'

class Rules
  include Movement
  include StateConditions

  attr_reader :chess_kit, :board, :game_state

  PIECE_TYPES = %i[pawn rook knight bishop queen king].freeze
  GAME_STATES = %i[playing check checkmate stalemate threefold_repetition fifty_move_inactivity insufficient_material surrender].freeze

  def initialize(chess_kit)
    @chess_kit = chess_kit
    @board = chess_kit.board
    self.game_state = :playing
  end

  def game_state=(new_state)
    raise ArgumentError, "Invalid state: #{new_state}" unless GAME_STATES.include?(new_state)

    @game_state = new_state
  end

  def deep_clone
    chess_kit_cloned = @chess_kit.deep_clone
    Rules.new(chess_kit_cloned)
  end
end
