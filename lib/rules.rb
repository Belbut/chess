require_relative './rules/movement_pattern/requirement'
require_relative './rules/movement_pattern/pattern_factory'
require_relative './rules/movement_pattern/tree_framework/root_position'

class Rules
  include PatternFactory

  attr_reader :board

  PIECE_TYPES = %i[pawn rook knight bishop queen king].freeze

  def initialize(board)
    @board = board
  end

  def deep_clone
    board_cloned = board.deep_clone
    Rules.new(board_cloned)
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

  def available_paths_for_piece(from_position)
    piece = @board.lookup_cell(from_position)
    rules = self
    team_color = piece.color
    safe_king_requirement = Requirement.move_is_safe_for_king(rules, team_color)

    all_possible_paths_to_position = all_possible_paths_to_position(from_position, piece.color, piece.type)
    all_possible_paths_to_position.map do |possible_path|
      possible_path.find_all do |possible_cord|
        safe_king_requirement.call(from_position, possible_cord)
      end
    end.reject(&:empty?)
  end

  private

  def generate_paths_for_piece(from_position, movement_patterns)
    movement_patterns.reduce([]) do |paths, pattern|
      paths + RootPosition.new(from_position, pattern).find_all_paths
    end
  end

  def movement_patterns_for_piece(color, type, move_type: :move)
    movement_pattern(move_type)[color][type]
  end

  def paths_to_position_by_piece(position, team_color, piece_type)
    attack_paths_from_pieces(position, team_color, piece_type)
  end

  def all_possible_paths_to_position(position, team_color, piece_type)
    movement_patterns = movement_patterns_for_piece(team_color, piece_type)

    generate_paths_for_piece(position, movement_patterns)
  end

  def all_possible_attack_paths_to_position(position, team_color, piece_type)
    movement_patterns = movement_patterns_for_piece(team_color, piece_type, move_type: :attack)

    generate_paths_for_piece(position, movement_patterns)
  end

  def attack_paths_from_pieces(position, team_color, piece_type)
    enemy_piece = Pieces::FACTORY[opposite_color(team_color)][piece_type]

    all_possible_attack_paths_to_position(position, team_color, piece_type).find_all do |path|
      board.lookup_cell(path.last) == enemy_piece
    end
  end

  def opposite_color(team_color)
    { white: :black, black: :white }[team_color]
  end
end
