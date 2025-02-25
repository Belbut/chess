require_relative './board'
require_relative '../chess_kit'

module FEN
  def self.load_game(fen)
    fen_data = parse(fen)

    chess_kit = ChessKit.new(
      fen_data[:board_algebraic_notation],
      fen_data[:current_color],
      fen_data[:half_move_count],
      fen_data[:full_move_count]
    )

    update_en_passant_rights(chess_kit, fen_data)
    update_castling_rights(chess_kit, fen_data)

    chess_kit
  end

  def self.update_en_passant_rights(chess_kit, fen_data)
    return unless fen_data[:en_passant_notation] != '-'

    position_of_en_passant = FEN.position_of_en_passant(current_color, en_passant_notation)
    chess_kit.board.lookup_cell(position_of_en_passant).mark_as_rushed
  end

  ROOK_CASTLING_POSITIONS = {
    'K' => 'H8', # White king-side rook
    'Q' => 'A8', # White queen-side rook
    'k' => 'H1', # Black king-side rook
    'q' => 'A1'  # Black queen-side rook
  }.freeze

  def self.update_castling_rights(chess_kit, fen_data)
    return if fen_data[:castling_notation] == '-'

    castling_codes = %w[K Q k q]
    remaining_castling_codes = fen_data[:castling_notation]
    moved_rooks_codes = castling_codes - remaining_castling_codes

    assign_rook_status(chess_kit, moved_rooks_codes)
  end

  def self.assign_rook_status(chess_kit, moved_rooks_codes)
    moved_rooks_codes.each do |rook_code|
      rook_coord = Coordinate.from_notation(ROOK_CASTLING_POSITIONS[rook_code])
      rook = chess_kit.board.lookup_cell(rook_coord)
      rook.mark_as_moved if rook.is_a?(Pieces::Rook)
    end
  end

  def self.generate(chess_kit)
    [
      chess_kit.board.to_algebraic_notation,
      chess_kit.current_color,
      castling_notation(chess_kit.board),
      en_passant_representation(chess_kit.board),
      chess_kit.half_move_count,
      chess_kit.full_move_count
    ].join(' ')
  end

  def self.piece_to_algebraic_notation(unit)
    notation = case unit.type
               when :pawn
                 'p'
               when :rook
                 'r'
               when :knight
                 'n'
               when :bishop
                 'b'
               when :queen
                 'q'
               when :king
                 'k'
               end

    unit.black? ? notation : notation.capitalize\
  end

  def self.algebraic_notation_to_piece(notation)
    standard_notation = notation.downcase
    color = notation == standard_notation ? :black : :white

    case standard_notation
    when 'p'
      Pieces::Pawn.new(color)
    when 'r'
      Pieces::Rook.new(color)
    when 'n'
      Pieces::Knight.new(color)
    when 'b'
      Pieces::Bishop.new(color)
    when 'q'
      Pieces::Queen.new(color)
    when 'k'
      Pieces::King.new(color)
    end
  end

  def self.parse(fen_message)
    fen_decomposition = fen_message.split(' ')

    board_algebraic_notation = Board.from_algebraic_notation(fen_decomposition[0])
    current_color = fen_decomposition[1].to_sym
    castling_notation = fen_decomposition[2].split('')
    en_passant_notation = fen_decomposition[3]
    half_move_count = fen_decomposition[4].to_i
    full_move_count = fen_decomposition[5].to_i

    { board_algebraic_notation: board_algebraic_notation,
      current_color: current_color,
      castling_notation: castling_notation,
      en_passant_notation: en_passant_notation,
      half_move_count: half_move_count,
      full_move_count: full_move_count }
  end

  def self.castling_notation(board)
    result = ''
    white_king = board.lookup_cell(Coordinate.from_notation('E1'))
    if white_king.is_a?(Pieces::King) && white_king.move_status == :unmoved
      king_side_rook = board.lookup_cell(Coordinate.from_notation('H1'))
      queen_side_rook = board.lookup_cell(Coordinate.from_notation('A1'))
      result.concat('K') if king_side_rook.is_a?(Pieces::Rook) && king_side_rook.move_status == :unmoved
      result.concat('Q') if queen_side_rook.is_a?(Pieces::Rook) && queen_side_rook.move_status == :unmoved
    end

    black_king = board.lookup_cell(Coordinate.from_notation('E8'))
    if black_king.is_a?(Pieces::King) && black_king.move_status == :unmoved
      king_side_rook = board.lookup_cell(Coordinate.from_notation('H8'))
      queen_side_rook = board.lookup_cell(Coordinate.from_notation('A8'))
      result.concat('k') if king_side_rook.is_a?(Pieces::Rook) && king_side_rook.move_status == :unmoved
      result.concat('q') if queen_side_rook.is_a?(Pieces::Rook) && queen_side_rook.move_status == :unmoved
    end

    if result == ''
      '-'
    else
      result
    end
  end

  def self.en_passant_representation(board)
    result = '-'
    rushed_pawn_position = find_position_rushed_pawn(board)

    unless rushed_pawn_position.nil?
      color = board.lookup_cell(rushed_pawn_position).color

      pawn_lagging_direction = color == :white ? -1 : +1
      pawn_lagging_position = Coordinate.new(rushed_pawn_position.x, rushed_pawn_position.y + pawn_lagging_direction)

      result = pawn_lagging_position.to_notation.downcase
    end

    result
  end

  def position_of_en_passant(current_color, notation)
    pawn_flank_position = Coordinate.from_notation(notation)
    pawn_rushed_direction = current_color == :w ? 1 : -1

    Coordinate.new(pawn_flank_position.x, pawn_flank_position.y + pawn_rushed_direction)
  end

  def self.find_position_rushed_pawn(board)
    board.find_position_of { |cell| cell.is_a?(Pieces::Pawn) && cell.move_status == :rushed }
  end
end
