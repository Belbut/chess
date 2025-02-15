require_relative './board'
module FEN
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

  def position_of_en_passant(current_player, notation)
    pawn_flank_position = Coordinate.from_notation(notation)
    pawn_rushed_direction = current_player == :w ? 1 : -1

    Coordinate.new(pawn_flank_position.x,pawn_flank_position.y+ pawn_rushed_direction)
  end

  def self.find_position_rushed_pawn(board)
    board.find_position_of { |cell| cell.is_a?(Pieces::Pawn) && cell.move_status == :rushed }
  end
end
