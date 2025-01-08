# frozen_string_literal: true

require_relative 'player'
require_relative 'chess_kit'
require_relative 'rules'

require_relative './rules/movement_pattern/root_position' # remove this

class Game
  attr_reader :chess_kit, :game_rules

  def initialize
    @white_player = Player.new(:white, Interface)
    @black_player = Player.new(:black, Interface)
    @current_player = @white_player

    @chess_kit = ChessKit.new
    @game_rules = GameRules.new(@chess_kit)
  end

  def play
    # setup game Interface.setup
    # loop game logic until we have game result
    #   one step of the loop is to change pawn status from rushed to moved on beginning of turn
    # present game result
  end

  def paths_of_picked_piece(from)
    piece = chess_kit.board.lookup_cell(from)

    game_rules.piece_pattern_rules(piece).reduce([]) do |reduce_memory, same_requirement_pattern_rules|
      reduce_memory + RootPosition.new(from, same_requirement_pattern_rules).find_all_paths
    end
  end

  # def make_move(from_coord, to_coord); end
end

# Chess is a Game
# This game is basically 2 Player 1 ChessKit 1 set of Rules and a Interface for the terminal.
#   The Player is a simple object with a name.
#   The ChessKit is basically:
#     1 Board of 8x8
#     and 32 Pieces
#       this pieces are either white or black
#       there is 6 different types of pieces
#         rook, knight, bishop, queen, king, pawn
#   The set of Rules were we need to define
#      how pieces move
#        on move event change move state unmoved -> moved // pawn : unmoved -> rushed/moved
#        each one moves differently
#          only knights are not obstructed by other pieces
#          king and rook - have a special move (castle)
#          pawn - has a lot of special cases for move
#            - first move of game
#            - en passant
#            - doesn't move the same way as it kills
#            - if it reaches the last row transforms into another piece
#      what makes a check
#        limits the moves to save the king
#      what makes a check-mate
#   The Interface
#     should prompt for player set up
#     new game / load_game
#     state the status of the game
#       -and FEN number
#     should present the board and pieces
#     should prompt for select piece// surrender // draw //  save game
#       - present the piece move options on board
#       - prompt for move
#       - send move to change board status
#     present game winner // draw
#
