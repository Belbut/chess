class Game
  def initialize
    # @white_player = Player.new()
    # @black_player = Player.new()
    # @current_player = white_player
    #
    # @board = Board.new()
  end

  def play
    # setup game Interface.setup
    # loop game logic until we have game result
    # present game result
  end
end

# Chess is a Game
# This game is basically 2 Player 1 Board 1 set of Rules and a Interface for the terminal.
#   The Player is a simple object with a name.
#   The Board is basically:
#     1 Grid of 8x8
#     and 32 Pieces
#       this pieces are either white or black
#       there is 6 different types of pieces
#         rook, knight, bishop, queen, king, pawn
#   The set of Rules were we need to define
#      how pieces move
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
