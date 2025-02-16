module Requirement
  def self.general_requirement(board, piece_color)
    lambda { |parent_cord, target_cord|
      target_is_inside_board(board).call(parent_cord, target_cord) &&
        parent_move_was_not_a_kill(board, piece_color).call(parent_cord, target_cord) &&
        target_is_no_friendly_kill(board, piece_color).call(parent_cord, target_cord)
    }
  end

  # all
  def self.target_is_inside_board(board)
    lambda { |_parent_cord, target_cord|
      board.inside_board?(target_cord)
    }
  end

  # all
  def self.parent_move_was_not_a_kill(board, team_color)
    lambda { |parent_cord, _target_cord|
      parent_unit = board.lookup_cell(parent_cord)

      parent_unit.nil? || parent_unit.color == team_color
    }
  end

  # all
  def self.target_is_no_friendly_kill(board, team_color)
    lambda { |_, target_cord|
      target_unit = board.lookup_cell(target_cord)

      target_unit.nil? || team_color != target_unit.color
    }
  end

  def self.move_is_safe_for_king(rules, team_color)
    lambda { |board_cord, testing_move_cord|
      rules_clone = rules.deep_clone

      moving_piece = rules_clone.board.clear_cell(board_cord)
      rules_clone.board.add_to_cell!(testing_move_cord, moving_piece)
      king_cord = rules_clone.board.find_position_of(Pieces::FACTORY[team_color][:king])

      king_is_safe = rules_clone.attackers_coordinates_to_position(king_cord, team_color).empty?
      king_is_safe
    }
  end

  # king & pawn
  # The king and the rook involved must not have moved before.
  def self.piece_not_moved(board)
    lambda { |parent_cord, _ = nil|
      parent_unit = board.lookup_cell(parent_cord)

      return false if parent_unit.nil?

      parent_unit.move_status == :unmoved
    }
  end

  # The squares between the king and the rook must be empty.
  def self.empty_row_between(board)
    lambda { |initial_cord, final_cord|
      coord_between(initial_cord, final_cord) { |target_cord| board.lookup_cell(target_cord).nil? }
    }
  end

  def self.safe_row_between(board, team_color)
    rules = Rules.new(board)

    lambda { |initial_cord, final_cord|
      coord_between(initial_cord, final_cord, mode: :inclusive) do |target_cord|
        rules.attackers_coordinates_to_position(target_cord, team_color).empty?
      end
    }
  end

  def self.empty_column_between(board)
    lambda { |initial_cord, final_cord|
      coord_between(initial_cord, final_cord) { |target_cord| board.lookup_cell(target_cord).nil? }
    }
  end

  def self.range_definition(start, stop, mode)
    case mode
    when :inclusive then (start..stop)
    when :exclusive then (start + 1...stop)
    else raise ArgumentError, 'Invalid mode'
    end
  end

  # only works in vertical or horizontal directions
  def self.coord_between(initial_cord, final_cord, mode: :exclusive)
    raise ArgumentError, 'Invalid direction' if initial_cord.x != final_cord.x && initial_cord.y != final_cord.y

    variable_axis, stable_axis = initial_cord.x != final_cord.x ? %i[x y] : %i[y x]

    start_axis, final_axis = [initial_cord.send(variable_axis), final_cord.send(variable_axis)].sort
    stable_number = initial_cord.send(stable_axis)

    range_definition(start_axis, final_axis, mode).all? do |axis_number|
      target_cord = case variable_axis
                    when :x
                      Coordinate.new(axis_number, stable_number)
                    when :y
                      Coordinate.new(stable_number, axis_number)
                    end
      yield(target_cord)
    end
  end

  # The king that makes the castling move has not yet moved in the game.
  # The rook that makes the castling move has not yet moved in the game.
  # The king is not in check.
  # The king does not move over a square that is attacked by an enemy piece during the castling move, i.e., when castling, there may not be an enemy piece that can move (in case of pawns: by diagonal movement) to a square that is moved over by the king.
  # The king does not move to a square that is attacked by an enemy piece during the castling move, i.e., you may not castle and end the move with the king in check.
  # All squares between the rook and king before the castling move are empty.
  # The King and rook must occupy the same rank (or row).
  RIGHT_CASTLE_ROOK_COLUMN = 7
  LEFT_CASTLE_ROOK_COLUMN = 0

  def self.can_castle(board, team_color)
    lambda { |parent_cord, target_cord|
      rook_cord = rook_position_from_castle_direction(parent_cord, target_cord)

      return false unless king_castle_conditions(board, parent_cord)
      return false unless rook_castle_condition(board, rook_cord)

      return false unless safe_row_between(board, team_color).call(parent_cord, rook_cord)
      return false unless empty_row_between(board).call(parent_cord, rook_cord)

      true
    }
  end

  def self.rook_position_from_castle_direction(parent_cord, target_cord)
    rook_column = target_cord.x > parent_cord.x ? RIGHT_CASTLE_ROOK_COLUMN : LEFT_CASTLE_ROOK_COLUMN
    rook_row = parent_cord.y

    Coordinate.new(rook_column, rook_row)
  end

  def self.king_castle_conditions(board, parent_cord)
    king = board.lookup_cell(parent_cord)

    king.is_a?(Pieces::King) && king.unmoved?
  end

  def self.rook_castle_condition(board, rook_cord)
    rook = board.lookup_cell(rook_cord)

    rook.is_a?(Pieces::Rook) && rook.unmoved?
  end

  # pawn
  def self.target_move_is_empty(board)
    lambda { |_, target_cord|
      target_unit = board.lookup_cell(target_cord)

      target_unit.nil?
    }
  end

  # pawn
  def self.target_move_is_kill(board, team_color)
    lambda { |_, target_cord|
      target_unit = board.lookup_cell(target_cord)

      return false if target_unit.nil?

      target_unit.color != team_color
    }
  end

  # pawn
  def self.target_move_is_flank_kill(board, team_color)
    lambda { |parent_cord, target_cord|
      rushed_flank = board.lookup_cell(Coordinate.new(target_cord.x, parent_cord.y))

      return false if rushed_flank.nil?

      team_color != rushed_flank.color && rushed_flank.move_status == :rushed
    }
  end
end
