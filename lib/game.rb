# frozen_string_literal: true

require 'yaml'

require_relative 'chess_kit'
require_relative 'rules'
require_relative 'player'

class Game
  attr_reader :chess_kit, :rules, :history, :white_player, :black_player

  FILE_WITH_SAVED_GAME = './database.yml'

  def initialize
    @history = []

    Interface.game_greeting
    case Interface.load_or_new_game
    when :new_game
      new_game
    when :load_game
      load_last_game
    end
  end

  def encode_with(coder)
    coder['history'] = @history
  end

  def save
    File.open(FILE_WITH_SAVED_GAME, 'w') do |file|
      file.write(YAML.dump(self))
    end
  end

  def load
    data = YAML.safe_load_file(FILE_WITH_SAVED_GAME, permitted_classes: [Symbol, Game])
    @history = data.instance_variable_get('@history')

    current_fen = @history.last[:fen]
    @chess_kit = ChessKit.from_fen(current_fen)
    @rules = Rules.new(@chess_kit)
  end

  def new_game
    Interface.new_match_intro
    @white_player = Player.new(:white)
    @black_player = Player.new(:black)
    puts("\nGame setup complete. \"#{@white_player.name}\" will play as White, and \"#{@black_player.name}\" will play as Black.")

    @chess_kit = ChessKit.new_game
    @rules = Rules.new(@chess_kit)
  end

  def load_last_game
    self.load
    Interface.load_match_intro(@chess_kit)
    @white_player = Player.new(:white)
    @black_player = Player.new(:black)
    puts("\nGame setup complete. \"#{@white_player.name}\" will play as White, and \"#{@black_player.name}\" will play as Black.")
  end

  def play
    loop do
      game_round

      break if game_should_end(@history)
    end
  end

  def game_should_end(history = [])
    if @rules.checkmate_condition? || @rules.draw_condition?(history) || @rules.game_state == :surrender
      Interface.end_game_message(self)
      return true
    end

    Interface.check_message if @rules.check_condition?
    false
  end

  def game_round
    catch(:surrender) do
      from, to = Interface.get_round_moves(self)

      @chess_kit.make_move(from, to)
      @history.append({ move: (from.to_notation + to.to_notation), fen: @chess_kit.to_fen })

      Interface.display_chess_board(@chess_kit)
    end
  end
end
