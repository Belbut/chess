require_relative '../chess_kit/coordinate'

module InitialPiecePositions
  WHITE_POSITIONS = {
    pawn: %w[A2 B2 C2 D2 E2 F2 G2 H2],
    rook: %w[A1 H1],
    knight: %w[B1 G1],
    bishop: %w[C1 F1],
    queen: %w[D1],
    king: %w[E1]
  }.freeze

  BLACK_POSITIONS = {
    pawn: %w[A7 B7 C7 D7 E7 F7 G7 H7],
    rook: %w[A8 H8],
    knight: %w[B8 G8],
    bishop: %w[C8 F8],
    queen: %w[D8],
    king: %w[E8]
  }.freeze

  PIECE_POSITIONS = {
    white: WHITE_POSITIONS,
    black: BLACK_POSITIONS
  }.freeze
end
