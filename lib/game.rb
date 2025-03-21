# frozen_string_literal: true

require_relative './player'
require_relative './chess_kit'
require_relative './rules'

class Game
  attr_reader :chess_kit, :rules, :history, :white_player, :black_player

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
    @rules = Rules.new(@chess_kit)
  end

  def play
    loop do
      game_round

      break if game_should_end(@history)
    end
  end

  def game_should_end(history = [])
    if @rules.checkmate_condition? || @rules.draw_condition?(history)
      end_game_message
      return true
    end

    Interface.check_message if @rules.check_condition?
    false
  end

  private

  def game_round
    from, to = Interface.get_round_moves(@chess_kit, @rules)

    @chess_kit.make_move(from, to)
    @history.append({ move: (from.to_notation + to.to_notation), fen: @chess_kit.to_fen })

    Interface.display_chess_board(@chess_kit)
  end

  def end_game_message
    if @rules.game_state == :checkmate
      checkmate_message
    else
      Interface.draw_message(@rules.game_state)
    end
  end

  def checkmate_message
    current_player_color = @chess_kit.current_color_name
    winner_color = ChessKit.opposite_color(current_player_color)

    winner_name = Player.name_from_color(self, winner_color)

    Interface.checkmate(current_player_color, winner_name)
  end
end
