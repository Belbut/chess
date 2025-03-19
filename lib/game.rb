# frozen_string_literal: true

require_relative './player'
require_relative './chess_kit'
require_relative './rules'

class Game
  attr_reader :chess_kit

  SKIP = true
  def initialize
    @history = []

    SKIP || Interface.game_greeting
    SKIP || case Interface.load_or_new_game
            when :new_game
              new_game
            when :load_game
              load_last_game
            end
    new_game
  end

  def new_game
    SKIP || Interface.new_match_intro
    SKIP || @white_player = Player.new(:white)
    SKIP || @black_player = Player.new(:black)
    SKIP || puts("\nGame setup complete. \"#{@white_player.name}\" will play as White, and \"#{@black_player.name}\" will play as Black.")

    @chess_kit = ChessKit.new_game
    @rules = Rules.new(@chess_kit.board)
  end

  def play
    loop do
      game_round

      break if game_should_end
    end
  end

  private

  def player_name_from_color(color)
    case color
    when :white
      @white_player
    when :black
      @black_player
    end
  end

  def game_round
    from, to = Interface.get_round_moves(@chess_kit, @rules)

    @chess_kit.make_move(from, to)
    @history.append({ move: (from.to_notation + to.to_notation), fen: @chess_kit.to_fen })

    Interface.display_chess_board(@chess_kit)
  end

  def game_should_end
    return true if checkmate_condition? || draw_condition?

    Interface.check_message if check_condition?
    false
  end

  def draw_condition?
    #   Stalemate – The player to move has no legal moves but is not in check, leading to a draw.
    #   Threefold Repetition – If the same position occurs three times with the same player to move, either player can claim a draw.
    #   Fifty-Move Rule – If no pawn has moved and no piece has been captured in the last 50 moves by both players, a draw can be claimed.
    #   Insufficient Material – If neither player has enough pieces to checkmate the opponent (e.g., king vs. king, or king and knight vs. king), the game is declared a draw.

    stalemate_condition? || threefold_condition? || fifty_move_condition? || insufficient_material?
  end

  def stalemate_condition?
    !any_legal_moves? && !check_condition?
  end

  def checkmate_condition?
    !any_legal_moves? && check_condition?
  end

  def threefold_condition?
    position_count = Hash.new(0)

    @history.each do |entry|
      game_position = entry[:fen].split[0, 4].join

      position_count[game_position] += 1
      return true if position_count[game_position] >= 3
    end
    false
  end

  def fifty_move_condition?
    @chess_kit.half_move_count >= (50 * 2)
  end

  def insufficient_material?
    all_pieces = @chess_kit.board.find_all { |cell| cell.is_a?(Unit) }

    return false if all_pieces.size > 4

    insufficient_material_for_checkmate?(all_pieces)
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
    bishop_positions = @chess_kit.board.find_all_positions_of { |cell| cell.type == :bishop }

    bishop_square_colors = bishop_positions.map do |position|
      (position.x + position.y).even? ? :dark : :light
    end

    bishop_square_colors.uniq.size == 1
  end

  def any_legal_moves?
    all_player_pieces_positions = @chess_kit.board.find_all_positions_of do |cell|
      cell.color == @chess_kit.current_color_name
    end

    return true if all_player_pieces_positions.any? do |piece_position|
      @rules.available_paths_for_piece(piece_position).any?
    end

    false
  end

  def checkmate_message
    current_player_color = @chess_kit.current_color_name
    winner_color = ChessKit.opposite_color(current_player_color)

    winner_name = player_name_from_color(winner_color)

    Interface.checkmate(current_player_color, winner_name)
  end

  def check_condition?
    king_cord = @rules.board.find_position_of(Pieces::FACTORY[@chess_kit.current_color_name][:king])

    @rules.attackers_coordinates_to_position(king_cord, @chess_kit.current_color_name).any?
  end
end
