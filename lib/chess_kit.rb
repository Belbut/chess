# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative '../lib/rules/initial_piece_positions'
class ChessKit
  attr_reader :board, :current_player, :half_move_count, :full_move_count

  # rows = height // columns = width
  BOARD_SIZE = { rows: 8, columns: 8 }.freeze

  def initialize(board_copy, current_player, half_move_count, full_move_count)
    @board = board_copy
    @current_player = current_player
    @half_move_count = half_move_count
    @full_move_count = full_move_count
  end

  def self.new_game
    chess_kit = new(Board.new(BOARD_SIZE[:rows], BOARD_SIZE[:columns]), :w, 0, 1)
    chess_kit.place_initial_pieces

    chess_kit
  end

  def self.from_fen(fen)
    FEN.load_game(fen)
  end

  def deep_clone
    board_cloned = board.deep_clone
    new(board_cloned, current_player, half_move_count, full_move_count)
  end

  def to_s
    Interface::Output.render_game(board)
  end

  def to_fen
    FEN.generate(self)
  end

  def make_move(_from, _to)
    update_current_player
    increase_full_move_count
  end

  def update_current_player
    @current_player == :w ? :b : :w
  end

  def reset_half_move_count
    @half_move_count = 0
  end

  def increase_half_move_count
    @half_move_count += 1
  end

  def increase_full_move_count
    @full_move_count += 1
  end

  def place_initial_pieces
    place_color_pieces_on_board(:white)
    place_color_pieces_on_board(:black)
  end

  private

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
