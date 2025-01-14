require_relative './rules/movement_pattern/requirement'
require_relative './rules/movement_pattern/root_position'
class Rules
  attr_reader :chess_kit

  PIECE_TYPES = %i[pawn rook knight bishop queen king].freeze

  def initialize(chess_kit)
    @chess_kit = chess_kit
  end

  def deep_clone
    chess_kit_cloned = chess_kit.deep_clone
    Rules.new(chess_kit_cloned)
  end

  def attackers_coordinates_to_position(position, team_color)
    attacker_coordinates = attack_paths_to_position(position, team_color).map(&:last)

    attacker_coordinates.flatten
  end

  def attack_paths_to_position(position, team_color)
    attack_paths = []

    PIECE_TYPES.each do |piece_type|
      attack_paths += paths_to_position_by_piece(position, team_color, piece_type)
    end
    attack_paths
  end

  def available_moves_for_piece(from_position)
    piece = board.lookup_cell(from_position)
    movement_patterns = movement_patterns_for_piece(piece.color, piece.type, ensure_king_safety: true)

    generate_paths_for_piece(from_position, movement_patterns)
  end

  private

  def generate_paths_for_piece(from_position, movement_patterns)
    movement_patterns.reduce([]) do |paths, pattern|
      paths + RootPosition.new(from_position, pattern).find_all_paths
    end
  end

  def movement_patterns_for_piece(color, type, ensure_king_safety:)
    movement_pattern_factory(ensure_king_safety)[color][type]
  end

  def paths_to_position_by_piece(position, team_color, piece_type)
    attack_paths_from_pieces(position, team_color, piece_type)
  end

  def all_possible_paths_to_position(position, team_color, piece_type)
    movement_patterns = movement_patterns_for_piece(team_color, piece_type, ensure_king_safety: false)

    generate_paths_for_piece(position, movement_patterns)
  end

  def attack_paths_from_pieces(position, team_color, piece_type)
    enemy_piece = Pieces::FACTORY[opposite_color(team_color)][piece_type]

    all_possible_paths_to_position(position, team_color, piece_type).find_all do |path|
      board.lookup_cell(path.last) == enemy_piece
    end
  end

  def opposite_color(team_color)
    { white: :black, black: :white }[team_color]
  end

  def board
    chess_kit.board
  end

  def movement_pattern_factory(ensure_king_safety)
    if ensure_king_safety
      { white: color_pattern_rules_restricted(:white),
        black: color_pattern_rules_restricted(:black) }
    else
      { white: color_pattern_rules_general(:white),
        black: color_pattern_rules_general(:black) }
    end
  end

  def color_pattern_rules_general(color)
    { pawn: pawn_moves(color),
      rook: rook_moves(color),
      knight: knight_moves(color),
      bishop: bishop_moves(color),
      queen: queen_moves(color),
      king: king_moves(color) }
  end

  def color_pattern_rules_restricted(color)
    { pawn: pawn_moves(color),
      rook: rook_moves2(color),
      knight: knight_moves2(color),
      bishop: bishop_moves2(color),
      queen: queen_moves2(color),
      king: king_moves2(color) }
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

  def rook_moves2(piece_color)
    [PatternRules.new([[:n, 0], [0, :n]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color),
                      Requirement.move_is_safe_for_king(self, piece_color))]
  end

  def knight_moves(piece_color)
    [PatternRules.new([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                       [-1, +2], [-1, -2], [-2, 1], [-2, -1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def knight_moves2(piece_color)
    [PatternRules.new([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                       [-1, +2], [-1, -2], [-2, 1], [-2, -1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color),
                      Requirement.move_is_safe_for_king(self, piece_color))]
  end

  def bishop_moves(piece_color)
    [PatternRules.new([%i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def bishop_moves2(piece_color)
    [PatternRules.new([%i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color),
                      Requirement.move_is_safe_for_king(self, piece_color))]
  end

  def queen_moves(piece_color)
    [PatternRules.new([[:n, 0], [0, :n], %i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def queen_moves2(piece_color)
    [PatternRules.new([[:n, 0], [0, :n], %i[n n], %i[n nn]],
                      Requirement.target_is_inside_board(board),
                      Requirement.parent_move_was_not_a_kill(board, piece_color),
                      Requirement.target_is_no_friendly_kill(board, piece_color),
                      Requirement.move_is_safe_for_king(self, piece_color))]
  end

  def king_moves(piece_color)
    [PatternRules.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.target_is_no_friendly_kill(board, piece_color))]
  end

  def king_moves2(piece_color)
    [PatternRules.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]],
                      Requirement.target_is_inside_board(board),
                      Requirement.target_is_no_friendly_kill(board, piece_color),
                      Requirement.no_suicide_move(piece_color, self))]
  end
end
