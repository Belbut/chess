module PatternFactory
  def movement_pattern
    { white: color_pattern_rules(:white),
      black: color_pattern_rules(:black) }
  end

  private

  def color_pattern_rules(color)
    { pawn: pawn_moves(color),
      rook: rook_moves(color),
      knight: knight_moves(color),
      bishop: bishop_moves(color),
      queen: queen_moves(color),
      king: king_moves(color) }
  end

  def pawn_moves(piece_color)
    [pawn_normal_moves(piece_color), pawn_rush_moves(piece_color),
     pawn_normal_take_moves(piece_color), pawn_flank_take_moves(piece_color)]
  end

  def pawn_normal_take_moves(piece_color)
    color_direction = piece_color == :white ? 1 : -1

    PatternRules.new([[-1, color_direction], [1, color_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_kill(board, piece_color))
  end

  def pawn_flank_take_moves(piece_color)
    color_direction = piece_color == :white ? 1 : -1

    PatternRules.new([[-1, color_direction], [1, color_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_flank_kill(board, piece_color))
  end

  def pawn_normal_moves(piece_color)
    color_direction = piece_color == :white ? 1 : -1
    PatternRules.new([[0, color_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_move_is_empty(board))
  end

  def pawn_rush_moves(piece_color)
    color_direction = piece_color == :white ? 2 : -2
    PatternRules.new([[0, color_direction]],
                     Requirement.piece_not_moved(board),
                     Requirement.target_is_inside_board(board),
                     Requirement.empty_column_between(board),
                     Requirement.target_move_is_empty(board))
  end

  def pawn_kill_pattern(piece_color)
    color_direction = piece_color == :white ? 1 : -1
    PatternRules.new([[0, color_direction]],
                     Requirement.target_is_inside_board(board),
                     Requirement.target_is_no_friendly_kill(board, piece_color))
  end

  def rook_moves(piece_color)
    [PatternRules.new([[:n, 0], [0, :n]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def knight_moves(piece_color)
    [PatternRules.new([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                       [-1, +2], [-1, -2], [-2, 1], [-2, -1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def bishop_moves(piece_color)
    [PatternRules.new([%i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def queen_moves(piece_color)
    [PatternRules.new([[:n, 0], [0, :n], %i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def king_moves(piece_color)
    [PatternRules.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end
end
