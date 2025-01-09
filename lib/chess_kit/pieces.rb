require_relative './pieces/pawn'
require_relative './pieces/noble_pieces'

module Pieces
  def self.create_piece(color)
    { pawn: Pieces::Pawn.new(color),
      rook: Pieces::Rook.new(color),
      knight: Pieces::Knight.new(color),
      bishop: Pieces::Bishop.new(color),
      queen: Pieces::Queen.new(color),
      king: Pieces::King.new(color) }
  end

  FACTORY = { white: create_piece(:white),
              black: create_piece(:black) }.freeze

end
