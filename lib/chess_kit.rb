# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'
require_relative '../lib/rules/initial_piece_positions'

class ChessKit
  attr_reader :board, :current_color, :half_move_count, :full_move_count

  # rows = height // columns = width
  BOARD_SIZE = { rows: 8, columns: 8 }.freeze

  def initialize(board_copy, current_color, half_move_count, full_move_count)
    @board = board_copy
    @current_color = current_color
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

  def place_initial_pieces
    place_color_pieces_on_board(:white)
    place_color_pieces_on_board(:black)
  end

  def to_s
    Interface::Output.render_game(board)
  end

  def to_fen
    FEN.generate(self)
  end

  def deep_clone
    board_cloned = board.deep_clone
    ChessKit.new(board_cloned, current_color, half_move_count, full_move_count)
  end

  def make_move(from, to)
    moving_piece = board.lookup_cell_content(from)
    target = board.lookup_cell_content(to)

    validate_move(moving_piece, target)

    process_move_effects(moving_piece, target, from, to)
    board.move_piece(from, to)
  end

  def current_color_name
    case current_color
    when :w then :white
    when :b then :black
    else raise "Invalid color: #{current_color}"
    end
  end

  def opponent_color_name
    self.class.opposite_color(current_color_name)
  end

  def current_player_owns_piece_at?(target_coord)
    target = board.lookup_cell_content(target_coord)

    target.is_a?(Unit) && piece_belongs_to_current_player?(target)
  end

  def self.opposite_color(team_color)
    { white: :black, black: :white }[team_color]
  end

  private

  def validate_move(moving_piece, target)
    unless piece_belongs_to_current_player?(moving_piece)
      raise ArgumentError, 'The moving piece does not belong to the current player'
    end

    return unless target.is_a?(Unit) && piece_belongs_to_current_player?(target)

    raise ArgumentError, 'The target cell is the same color'
  end

  def piece_belongs_to_current_player?(piece)
    piece.color == current_color_name
  end

  def process_move_effects(moving_piece, target, from, to)
    process_special_move_cases(moving_piece, from, to)

    update_trackers(moving_piece, target, from, to)
  end

  def process_special_move_cases(moving_piece, from, to)
    process_en_passant(moving_piece, from, to)
    process_castle(moving_piece, from, to)
  end

  def process_en_passant(moving_piece, from, to)
    return unless moving_piece.is_a?(Pieces::Pawn)

    rules = Rules.new(self)
    possible_en_passant = rules.possible_flanks_for_en_passant(from)

    possible_en_passant.each do |en_passant_move|
      board.clear_cell(en_passant_move[:target]) if en_passant_move[:flank] == to
    end
  end

  def process_castle(moving_piece, from, to)
    return unless move_is_castle(moving_piece, from, to)

    rook_coord = Requirement.rook_position_of_castle(from, to)
    rook_target_coord = Requirement.rook_target_position_of_castle(from, to)

    rook = board.lookup_cell_content(rook_coord)
    raise "Rook not found at #{rook_coord}" unless rook

    board.move_piece(rook_coord, rook_target_coord)
    rook.mark_as_moved
  end

  def move_is_castle(moving_piece, from, to)
    moving_piece.is_a?(Pieces::King) && Coordinate.distance_between(from, to) >= 2
  end

  def update_trackers(moving_piece, target, from, to)
    update_move_status(moving_piece, from, to)
    update_current_color
    update_full_move_count
    update_half_move_count(moving_piece, target)
  end

  def update_move_status(moving_piece, from, to)
    board.find { |piece| piece.move_status == :rushed }&.mark_as_moved

    if moving_piece.is_a?(Pieces::Pawn) && Coordinate.distance_between(from, to) >= 2
      moving_piece.mark_as_rushed
    else
      moving_piece.mark_as_moved
    end
  end

  def update_current_color
    @current_color = @current_color == :w ? :b : :w
  end

  def update_full_move_count
    @full_move_count += 1 if @current_color == :w
  end

  def update_half_move_count(moving_piece, target)
    @half_move_count += 1
    @half_move_count = 0 if moving_piece.is_a?(Pieces::Pawn) || !target.nil?
  end

  def reset_half_move_count
    @half_move_count = 0
  end

  def increase_half_move_count
    @half_move_count += 1
  end

  def place_color_pieces_on_board(color)
    InitialPiecePositions::PIECE_POSITIONS[color].each_pair do |piece_type, all_positions|
      piece = Pieces::FACTORY[color][piece_type]
      all_positions.each do |position_notation|
        coord = Coordinate.from_notation(position_notation)
        @board.add_to_cell_content(coord, piece.dup)
      end
    end
  end
end
