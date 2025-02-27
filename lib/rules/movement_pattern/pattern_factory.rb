module PatternFactory
  def movement_pattern(move_type = nil)
    { white: color_pattern_rules(:white, move_type),
      black: color_pattern_rules(:black, move_type) }
  end

  private

  def color_pattern_rules(color, move_type = nil)
    { pawn: pawn_move_pattern(color, move_type),
      rook: rook_move_pattern(color),
      knight: knight_move_pattern(color),
      bishop: bishop_move_pattern(color),
      queen: queen_move_pattern(color),
      king: king_move_pattern(color, move_type) }
  end

  def pawn_move_pattern(piece_color, move_type)
    return [pawn_normal_take_pattern(piece_color), pawn_flank_take_pattern(piece_color)] if move_type == :attack
    return [pawn_flank_take_pattern(piece_color)] if move_type == :en_passant

    [pawn_normal_move_pattern(piece_color), pawn_rush_move_pattern(piece_color),
     pawn_normal_take_pattern(piece_color), pawn_flank_take_pattern(piece_color)]
  end

  def pawn_color_move_direction(piece_color)
    piece_color == :white ? 1 : -1
  end

  def pawn_normal_take_pattern(piece_color)
    move_direction = pawn_color_move_direction(piece_color)

    PatternRules.new([[-1, move_direction], [1, move_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_kill(board, piece_color))
  end

  def pawn_flank_take_pattern(piece_color)
    move_direction = pawn_color_move_direction(piece_color)

    PatternRules.new([[-1, move_direction], [1, move_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_flank_kill(board, piece_color))
  end

  def pawn_normal_move_pattern(piece_color)
    move_direction = pawn_color_move_direction(piece_color)

    PatternRules.new([[0, move_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_empty(board))
  end

  def pawn_rush_move_pattern(piece_color)
    move_direction = pawn_color_move_direction(piece_color) * 2

    PatternRules.new([[0, move_direction]],
                     Requirement.piece_not_moved(board),
                     Requirement.target_is_inside_board(board),
                     Requirement.empty_column_between(board),
                     Requirement.target_move_is_empty(board))
  end

  def pawn_kill_pattern(piece_color)
    move_direction = pawn_color_move_direction(piece_color)

    PatternRules.new([[0, move_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_is_no_friendly_kill(board, piece_color))
  end

  def rook_move_pattern(piece_color)
    [PatternRules.new([[:n, 0], [0, :n]],
                      Requirement.general_requirement(board, piece_color))]
  end

  def knight_move_pattern(piece_color)
    [PatternRules.new([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                       [-1, +2], [-1, -2], [-2, 1], [-2, -1]],
                      Requirement.general_requirement(board, piece_color))]
  end

  def bishop_move_pattern(piece_color)
    [PatternRules.new([%i[n n], %i[n nn]],
                      Requirement.general_requirement(board, piece_color))]
  end

  def queen_move_pattern(piece_color)
    [PatternRules.new([[:n, 0], [0, :n], %i[n n], %i[n nn]],
                      Requirement.general_requirement(board, piece_color))]
  end

  def king_move_pattern(piece_color, move_type = nil)
    return [king_normal_move_pattern(piece_color)] if move_type == :attack

    [king_normal_move_pattern(piece_color), king_castle_move_pattern(piece_color)]
  end

  def king_normal_move_pattern(piece_color)
    PatternRules.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]],
                     Requirement.general_requirement(board, piece_color))
  end

  def king_castle_move_pattern(piece_color)
    PatternRules.new([[-2, 0], [2, 0]], Requirement.target_is_inside_board(board),
                     Requirement.can_castle(board, piece_color))
  end
end
