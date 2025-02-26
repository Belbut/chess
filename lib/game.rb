# frozen_string_literal: true

require_relative './player'
require_relative './chess_kit'
require_relative './rules'

class Game
  SKIP = true
  def initialize
    SKIP || Interface.game_greeting
    SKIP || case Interface.load_or_new_game
            when :new_game
              new_game
            when :load_game
              load_last_game
            end
    new_game
  end

  def new_game
    SKIP || Interface.new_match_intro
    SKIP || @white_player = Player.new(:white)
    SKIP || @black_player = Player.new(:black)
    SKIP || puts("\nGame setup complete. \"#{@white_player.name}\" will play as White, and \"#{@black_player.name}\" will play as Black.")

    @chess_kit = ChessKit.new_game
    @rules = Rules.new(@chess_kit.board)
  end

  def load_last_game; end

  def play
    loop do
      game_round

      break if game_should_end
    end
  end

  private

  def game_round
    from, to = Interface.get_round_moves(@chess_kit, @rules)

    @chess_kit.make_move(from, to)
    Interface.display_chess_board(@chess_kit)
  end

  def game_should_end
    :black if false
    :white if false
    :draw if false
  end
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
