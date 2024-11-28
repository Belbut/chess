# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative '../lib/rules/initial_piece_positions'
class ChessKit
  attr_reader :board

  # rows = height // columns = width
  BOARD_SIZE = { rows: 8, columns: 8 }.freeze

  def initialize
    @board = Board.new(BOARD_SIZE[:rows], BOARD_SIZE[:columns])
    place_initial_pieces
  end

  private

  def place_initial_pieces
    place_color_pieces_on_board(:white)
    place_color_pieces_on_board(:black)
  end

  def place_color_pieces_on_board(color)
    InitialPiecePositions::PIECE_POSITIONS[color].each_pair do |pice_type, all_positions|
      piece = Pieces::FACTORY[color][pice_type]
      all_positions.each do |position_notation|
        coord = Coordinate.from_notation(position_notation)
        @board.add_to_cell(coord, piece)
      end
    end
  end
end
