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

      moving_piece = rules_clone.chess_kit.board.clear_cell(board_cord) # problem with this
      rules_clone.chess_kit.board.add_to_cell!(testing_move_cord, moving_piece)
      king_cord = rules_clone.chess_kit.board.find_position_of(Pieces::FACTORY[team_color][:king])

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

  def self.no_suicide_move(team_color, rules)
    lambda { |_, target_cord|
      rules.attackers_coordinates_to_position(target_cord, team_color).empty?
    }
  end

  # The squares between the king and the rook must be empty.
  def self.empty_row_between(board)
    lambda { |initial_cord, final_cord|
      return false unless initial_cord.y == final_cord.y # Ensure same row

      start_x, end_x = [initial_cord.x, final_cord.x].sort
      yy = initial_cord.y

      (start_x + 1..end_x - 1).all? do |row_number|
        target_cord = Coordinate.new(row_number, yy)
        board.lookup_cell(target_cord).nil?
      end
    }
  end

  def self.empty_column_between(board)
    lambda { |initial_cord, final_cord|
      return false unless initial_cord.x == final_cord.x # Ensure same column

      start_y, end_y = [initial_cord.y, final_cord.y].sort
      xx = initial_cord.x

      (start_y + 1..end_y - 1).all? do |column_number|
        target_cord = Coordinate.new(xx, column_number)
        board.lookup_cell(target_cord).nil?
      end
    }
  end

  # The king must not currently be in check.
  # The king must not move through or land on a square that is under attack.
  def self.cell_not_under_attack(rules, team_color)
    lambda { |_parent_cord, target_cord|
      rules.attackers_coordinates_to_position(target_cord, team_color).empty?
    }
  end

  def self.left_side_castle(board); end

  def self.right_side_castle(board); end

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
