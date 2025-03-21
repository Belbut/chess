module StateConditions
  def check_condition?
    king_cord = board.find_position_of(Pieces::FACTORY[@chess_kit.current_color_name][:king])

    game_state_and_return(:check) if attackers_coordinates_to_position(king_cord,
                                                                       @chess_kit.current_color_name).any?
  end

  def checkmate_condition?
    return game_state_and_return(:checkmate) if !any_legal_moves? && check_condition?

    false
  end

  def draw_condition?(history)
    stalemate_condition? || threefold_condition?(history) || fifty_move_condition? || insufficient_material?
  end

  private

  def stalemate_condition?
    game_state_and_return(:stalemate) if !any_legal_moves? && !check_condition?
  end

  def threefold_condition?(history)
    position_count = Hash.new(0)

    history.each do |entry|
      game_position = entry[:fen].split[0, 4].join

      position_count[game_position] += 1
      return game_state_and_return(:threefold_repetition) if position_count[game_position] >= 3
    end
    false
  end

  def fifty_move_condition?
    game_state_and_return(:fifty_move_inactivity) if @chess_kit.half_move_count >= (50 * 2)
  end

  def insufficient_material?
    all_pieces = board.find_all { |cell| cell.is_a?(Unit) }

    return false if all_pieces.size > 4

    game_state_and_return(:insufficient_material) if insufficient_material_for_checkmate?(all_pieces)
  end

  def insufficient_material_for_checkmate?(all_pieces)
    pieces_count_by_color = count_pieces_by_color(all_pieces)

    case pieces_count_by_color.values.sort_by { |piece_counts| piece_counts.keys.size }
    when [{ king: 1 }, { king: 1 }], [{ king: 1 }, { king: 1, bishop: 1 }], [{ king: 1 }, { king: 1, knight: 1 }]
      true
    when [{ king: 1, bishop: 1 }, { king: 1, bishop: 1 }]
      bishops_on_same_color?
    else
      false
    end
  end

  def count_pieces_by_color(all_pieces)
    pieces_per_color = all_pieces.each_with_object({ black: [], white: [] }) do |piece, grouped_pieces|
      grouped_pieces[piece.color] << piece.type
    end

    pieces_per_color.transform_values(&:tally)
  end

  def bishops_on_same_color?
    bishop_positions = board.find_all_positions_of { |cell| cell.type == :bishop }

    bishop_square_colors = bishop_positions.map do |position|
      (position.x + position.y).even? ? :dark : :light
    end

    bishop_square_colors.uniq.size == 1
  end

  def any_legal_moves?
    all_player_pieces_positions = board.find_all_positions_of do |cell|
      cell.color == @chess_kit.current_color_name
    end

    return true if all_player_pieces_positions.any? do |piece_position|
      available_paths_for_piece(piece_position).any?
    end

    false
  end

  def game_state_and_return(game_state)
    self.game_state = game_state and return true
  end
end
