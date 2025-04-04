require_relative './movement_pattern/requirement'
require_relative './movement_pattern/pattern_factory'
require_relative './movement_pattern/tree_framework/root_position'

module Movement
  include PatternFactory

  def attackers_coordinates_to_position(position, team_color)
    attacker_coordinates = attack_paths_to_position(position, team_color).map(&:last)

    attacker_coordinates.flatten
  end

  def attack_paths_to_position(position, team_color)
    attack_paths = []

    Rules::PIECE_TYPES.each do |piece_type|
      attack_paths += paths_to_position_by_piece(position, team_color, piece_type)
    end
    attack_paths
  end

  def available_paths_for_piece(from_position)
    piece = @board.lookup_cell_content(from_position)
    rules = self
    team_color = piece.color
    safe_king_requirement = Requirement.move_is_safe_for_king(rules, team_color)

    all_possible_paths_to_position = possible_movement_paths_to_position(from_position, piece.color, piece.type)

    all_possible_paths_to_position.map do |possible_path|
      possible_path.find_all do |possible_cord|
        safe_king_requirement.call(from_position, possible_cord)
      end
    end.reject(&:empty?)
  end

  def possible_flanks_for_en_passant(from_position)
    piece = @board.lookup_cell_content(from_position)
    return [] unless piece.is_a?(Pieces::Pawn)

    position_of_en_passant_flanks = possible_movement_paths_to_position(from_position, piece.color, :pawn,
                                                                        move_type: :en_passant).flatten

    position_of_en_passant_flanks.map do |flank_coord|
      { flank: flank_coord, target: target_coord(piece.color, flank_coord) }
    end
  end

  def opposite_color(team_color)
    { white: :black, black: :white }[team_color]
  end

  private

  def paths_to_position_by_piece(position, team_color, piece_type)
    attack_paths_from_pieces(position, team_color, piece_type)
  end

  def possible_movement_paths_to_position(position, team_color, piece_type, move_type: :move)
    movement_patterns = movement_patterns_for_piece(team_color, piece_type, move_type: move_type)

    generate_paths_for_piece(position, movement_patterns)
  end

  def movement_patterns_for_piece(color, type, move_type: :move)
    movement_pattern(move_type)[color][type]
  end

  def generate_paths_for_piece(from_position, movement_patterns)
    movement_patterns.reduce([]) do |paths, pattern|
      paths + RootPosition.new(from_position, pattern).find_all_paths
    end
  end

  def attack_paths_from_pieces(position, team_color, piece_type)
    enemy_color = ChessKit.opposite_color(team_color)
    enemy_piece = Pieces::FACTORY[enemy_color][piece_type]

    possible_movement_paths_to_position(position, team_color, piece_type, move_type: :attack).find_all do |path|
      board.lookup_cell_content(path.last) == enemy_piece
    end
  end

  def target_coord(piece_color, flank_coord)
    color_direction = { white: -1, black: 1 }
    xx = flank_coord.x
    yy = flank_coord.y + color_direction[piece_color]

    Coordinate.new(xx, yy)
  end
end
