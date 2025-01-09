require_relative './rules/movement_pattern/requirement'
require_relative './rules/movement_pattern/root_position'
class Rules
  attr_reader :chess_kit

  def initialize(chess_kit)
    @chess_kit = chess_kit
  end

  def piece_pattern_rules(piece)
    pattern_rules_factory[piece.color][piece.type]
  end

  def position_under_attack_from(position, team_color)
    list_of_attackers = position_under_attack_from_path(position, team_color).map(&:last)

    list_of_attackers.flatten
  end

  def position_under_attack_from_path(position, team_color)
    list_all_piece_types = %i[pawn rook knight bishop queen king]
    list_of_attackers = []

    list_all_piece_types.each do |piece_type|
      list_of_attackers += vulnerable_position_from_path(position, team_color, piece_type)
    end
    list_of_attackers
  end

  private

  def vulnerable_position_from_path(position, piece_color, piece_type)
    active_paths_to_position(position, piece_color, piece_type)
  end

  def all_paths_to_position(position, piece_color, piece_type)
    piece_pattern_rules = pattern_rules_factory[piece_color][piece_type]

    piece_pattern_rules.reduce([]) do |memory, same_requirement_pattern_rules|
      memory + RootPosition.new(position, same_requirement_pattern_rules).find_all_paths
    end
  end

  def active_paths_to_position(position, piece_color, piece_type)
    enemy_piece = Pieces::FACTORY[opposite_color(piece_color)][piece_type]

    all_paths_to_position(position, piece_color, piece_type).find_all do |possible_path|
      board.lookup_cell(possible_path.last) == enemy_piece
    end
  end

  def opposite_color(team_color)
    { white: :black, black: :white }[team_color]
  end

  def board
    chess_kit.board
  end

  def pattern_rules_factory
    {
      white: {
        pawn: pawn_moves(:white),
        rook: rook_moves(:white),
        knight: knight_moves(:white),
        bishop: bishop_moves(:white),
        queen: queen_moves(:white),
        king: king_moves(:white)
      },
      black: {
        pawn: pawn_moves(:black),
        rook: rook_moves(:black),
        knight: knight_moves(:black),
        bishop: bishop_moves(:black),
        queen: queen_moves(:black),
        king: king_moves(:black)

      }
    }
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
                     Requirement.parent_piece_not_moved(board),
                     Requirement.target_is_inside_board(board),
                     Requirement.empty_column_between(board),
                     Requirement.target_move_is_empty(board))
  end

  def pawn_kill_pattern(piece_color)
    color_direction = piece_color == :white ? 1 : -1
    PatternRules.new([[0, color_direction]],
                     Requirement.target_is_inside_board(board))
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

  def king_normal_moves(piece_color); end
end
