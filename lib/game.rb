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

  def load_last_game; end

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
    @history.append([from.to_notation, to.to_notation])

    Interface.display_chess_board(@chess_kit)
  end

  def game_should_end
    return true if checkmate_condition || draw_condition

    false
  end

  def draw_condition
    #   Stalemate – The player to move has no legal moves but is not in check, leading to a draw.
    #   Threefold Repetition – If the same position occurs three times with the same player to move, either player can claim a draw.
    #   Fifty-Move Rule – If no pawn has moved and no piece has been captured in the last 50 moves by both players, a draw can be claimed.
    #   Insufficient Material – If neither player has enough pieces to checkmate the opponent (e.g., king vs. king, or king and knight vs. king), the game is declared a draw.
  end

  def checkmate_condition
    all_player_pieces_positions = @chess_kit.board.find_all_positions_of do |cell|
      cell.is_a?(Unit) && cell.color == @chess_kit.current_color_name
    end

    return false if all_player_pieces_positions.any? do |piece_position|
      @rules.available_paths_for_piece(piece_position).any?
    end

    checkmate_message
    true
  end

  def checkmate_message
    current_player_color = @chess_kit.current_color_name
    winner_color = ChessKit.opposite_color(current_player_color)

    winner_name = player_name_from_color(winner_color)

    Interface.checkmate(current_player_color, winner_name)
  end
end
