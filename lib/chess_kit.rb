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

  def make_move(from, to)
    moving_piece = board.lookup_cell(from)
    target_cell = board.lookup_cell(to)

    if target_cell.is_a?(Unit) && moving_piece.color == (target_cell.color)
      return raise ArgumentError, 'The target cell is the same color'
    end

    if moving_piece.color != current_player_color
      return raise ArgumentError,
                   'The moving piece is not from the current player'
    end

    board.clear_cell(from)
    board.add_to_cell!(to, moving_piece)

    update_move_status(from, to)
    update_current_player
    update_full_move_count
    update_half_move_count(moving_piece, target_cell)
  end

  def place_initial_pieces
    place_color_pieces_on_board(:white)
    place_color_pieces_on_board(:black)
  end

  def update_full_move_count22222222222
    @full_move_count += 1 if @current_player == :w
  end

  private

  def update_move_status(from, to)
    board.find { |piece| piece.move_status == :rushed }&.mark_as_moved

    moving_piece = board.lookup_cell(to)
    if moving_piece.is_a?(Pieces::Pawn) && Coordinate.distance_between(from, to) >= 2
      moving_piece.mark_as_rushed
    else
      moving_piece.mark_as_moved
    end
  end

  def update_half_move_count(moving_piece, target_cell)
    @half_move_count += 1
    @half_move_count = 0 if moving_piece.is_a?(Pieces::Pawn) || !target_cell.nil?
  end

  def update_full_move_count
    @full_move_count += 1 if @current_player == :w
  end

  def update_current_player
    @current_player = @current_player == :w ? :b : :w
  end

  def current_player_color
    case current_player
    when :w
      :white
    when :b
      :black
    end
  end

  def reset_half_move_count
    @half_move_count = 0
  end

  def increase_half_move_count
    @half_move_count += 1
  end

  def place_color_pieces_on_board(color)
    InitialPiecePositions::PIECE_POSITIONS[color].each_pair do |pice_type, all_positions|
      piece = Pieces::FACTORY[color][pice_type]
      all_positions.each do |position_notation|
        coord = Coordinate.from_notation(position_notation)
        @board.add_to_cell(coord, piece.dup)
      end
    end
  end
end
