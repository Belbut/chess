require_relative '../chess_kit/coordinate'

module InitialPiecePositions
  def self.coordinate_from_array(positions)
    positions.map { |position| Coordinate.from_array(position) }
  end

  WHITE_POSITIONS = {
    pawn: coordinate_from_array([[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]),
    rook: coordinate_from_array([[0, 0], [7, 0]]),
    knight: coordinate_from_array([[1, 0], [6, 0]]),
    bishop: coordinate_from_array([[2, 0], [5, 0]]),
    queen: coordinate_from_array([[3, 0]]),
    king: coordinate_from_array([[4, 0]])
  }.freeze

  BLACK_POSITIONS = {
    pawn: coordinate_from_array([[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]),
    rook: coordinate_from_array([[0, 7], [7, 7]]),
    knight: coordinate_from_array([[1, 7], [6, 7]]),
    bishop: coordinate_from_array([[2, 7], [5, 7]]),
    queen: coordinate_from_array([[3, 7]]),
    king: coordinate_from_array([[4, 7]])
  }.freeze

  PIECE_POSITIONS = {
    white: WHITE_POSITIONS,
    black: BLACK_POSITIONS
  }.freeze
end
