module Requirement
  # all
  def self.target_is_inside_board(board)
    lambda { |_parent_cord, target_cord|
      board.inside_board?(target_cord)
    }
  end

  # all
  def self.parent_move_was_kill(board, team_color)
    lambda { |parent_cord, _target_cord|
      parent_unit = board.lookup_cell(parent_cord)

      !parent_unit.nil? && parent_unit.color != team_color
    }
  end

  # all
  def self.target_is_no_friendly_kill(board, team_color)
    lambda { |_, target_cord|
      target_unit = board.lookup_cell(target_cord)

      target_unit.nil? || team_color != target_unit.color
    }
  end

  def self.standard_requirements(board, team_color)
    # lambda { |parent_cord, target_cord|
    #   # puts '...1'
    #   # puts target_is_inside_board(board).call(parent_cord, target_cord)
    #   # puts '...2'
    #   # puts parent_move_was_kill(board, team_color).call(parent_cord, target_cord)
    #   # puts '...3'
    #   # puts target_is_no_friendly_kill(board, team_color).call(parent_cord, target_cord)
    #   # puts '...4'
    #   target_is_inside_board(board).call(parent_cord, target_cord) &&
    #     parent_move_was_kill(board, team_color).call(parent_cord, target_cord) &&
    #     target_is_no_friendly_kill(board, team_color).call(parent_cord, target_cord)
    # }
  end

  # king
  # The king and the rook involved must not have moved before.
  def self.parent_piece_not_moved(board)
    lambda { |parent_cord, _ = nil|
      parent_unit = board.lookup_cell(parent_cord)

      return false if parent_unit.nil?

      parent_unit.move_status == :unmoved
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

  # The king must not currently be in check.
  # The king must not move through or land on a square that is under attack.
  def self.cell_not_under_attack(board, team_color)
    lambda { |cell_cord|
      RootPosition.new(cell_cord,
                       PatternRules.new([[:n, 0], [0, :n]], Requirement.standard_requirements(board, team_color)))
    }
  end

  def self.left_side_castle(board); end

  def self.right_side_castle(board); end

  # pawn
  def self.target_move_no_kill(board)
    lambda { |parent_cord, target_cord|
      parent_unit = board.lookup_cell(parent_cord)
      target_unit = board.lookup_cell(target_cord)

      return true if parent_unit.nil? || target_unit.nil?

      parent_unit.color == target_unit.color
    }
  end

  # pawn
  def self.target_flank_rushed(board)
    lambda { |parent_cord, target_cord|
      parent_unit = board.lookup_cell(parent_cord)
      rushed_flank = board.lookup_cell(Coordinate.new(target_cord.x, parent_cord.y))

      return false if parent_unit.nil? || rushed_flank.nil?

      parent_unit.color != rushed_flank.color && rushed_flank.move_status == :rushed
    }
  end

  # # pawn
  # def self.rushed(board)
  #   lambda { |parent_cord, _ = nil|
  #     parent_unit = board.lookup_cell(parent_cord)

  #     return false if parent_unit.nil?

  #     parent_unit.move_status == :rushed
  #   }
  # end
end
