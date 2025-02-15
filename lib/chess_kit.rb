# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative '../lib/rules/initial_piece_positions'
class ChessKit
  attr_reader :board, :current_player, :half_move_count, :full_move_count

  # rows = height // columns = width
  BOARD_SIZE = { rows: 8, columns: 8 }.freeze

  def initialize(board_copy = nil, current_player = nil, half_move_count = nil, full_move_count = nil)
    @board = board_copy || Board.new(BOARD_SIZE[:rows], BOARD_SIZE[:columns])
    place_initial_pieces if board_copy.nil?
    @current_player = current_player || :w
    @half_move_count = half_move_count || 0
    @full_move_count = full_move_count || 1
  end

  def self.from_fen(fen)
    fen_decomposition = fen.split(' ')

    board_algebraic_notation = Board.from_algebraic_notation(fen_decomposition[0])
    current_player = fen_decomposition[1].to_sym
    castling_notation = fen_decomposition[2].split('')
    en_passant_notation = fen_decomposition[3]
    half_move_count = fen_decomposition[4].to_i
    full_move_count = fen_decomposition[5].to_i
    chess_kit = new(board_algebraic_notation, current_player, half_move_count, full_move_count)

    if en_passant_notation != '-'
      position_of_en_passant = FEN.position_of_en_passant(current_player, en_passant_notation)
      chess_kit.board.lookup_cell(position_of_en_passant).mark_as_rushed
    end

    if castling_notation != '-'
      template_castling = %w[K Q k q]
      notation_decomposition = castling_notation

      moved_pieces_codes = template_castling - notation_decomposition

      if moved_pieces_codes.any?('K')
        king_side_rook_coord = Coordinate.from_notation('H8')
        rook = chess_kit.board.lookup_cell(king_side_rook_coord)
        rook.mark_as_moved if rook.is_a?(Pieces::Rook)
      end
      if moved_pieces_codes.any?('Q')
        king_side_rook_coord = Coordinate.from_notation('A8')
        rook = chess_kit.board.lookup_cell(king_side_rook_coord)
        rook.mark_as_moved if rook.is_a?(Pieces::Rook)
      end
      if moved_pieces_codes.any?('k')
        king_side_rook_coord = Coordinate.from_notation('H1')
        rook = chess_kit.board.lookup_cell(king_side_rook_coord)
        rook.mark_as_moved if rook.is_a?(Pieces::Rook)
      end
      if moved_pieces_codes.any?('q')
        king_side_rook_coord = Coordinate.from_notation('A1')
        rook = chess_kit.board.lookup_cell(king_side_rook_coord)
        rook.mark_as_moved if rook.is_a?(Pieces::Rook)
      end
    end

    chess_kit
  end

  def deep_clone
    board_cloned = board.deep_clone
    ChessKit.new(board_cloned)
  end

  def to_s
    Interface::Output.render_game(board)
  end

  def to_fen
    [@board.to_algebraic_notation,
     @current_player,
     FEN.castling_notation(@board),
     FEN.en_passant_representation(@board),
     @half_move_count,
     @full_move_count].join(' ')
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
