# frozen_string_literal: true

require 'yaml'

require_relative 'chess_kit'
require_relative 'rules'
require_relative 'player'
require_relative 'stockfish_engine'

class Game
  attr_reader :chess_kit, :rules, :history, :white_player, :black_player, :stockfish_engine

  FILE_WITH_SAVED_GAME = './database.yml'

  def initialize
    @history = []

    Interface::Output.game_greeting
    case Interface::Input::FlowHandler.load_or_new_match
    when :new_match
      new_match
    when :load_match
      load_last_match
    end

    config_computer_chess_engine
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

  def new_match
    @chess_kit = ChessKit.new_match
    @rules = Rules.new(@chess_kit)

    Interface::Output.new_match_intro(@chess_kit)
    @white_player = Player.new(:white)
    @black_player = Player.new(:black)
    Interface::Output.players_created_intro(@white_player.name, @black_player.name)
  end

  def load_last_match
    self.load

    Interface::Output.load_match_intro(@chess_kit)
    @white_player = Player.new(:white)
    @black_player = Player.new(:black)
    Interface::Output.players_created_intro(@white_player.name, @black_player.name)
  end

  def play
    loop do
      game_round

      break if game_should_end(@history)
    end
  end

  private

  def game_should_end(history = [])
    if @rules.checkmate_condition? || @rules.draw_condition?(history) || @rules.game_state == :surrender
      Interface::Output.end_game_message(self)
      return true
    end

    Interface::Output.check_message if @rules.check_condition?
    false
  end

  def game_round
    catch(:surrender) do
      from, to = Interface::Input::FlowHandler.get_round_moves(self, current_player.type)

      @chess_kit.make_move(from, to)
      @history.append({ move: (from.to_notation + to.to_notation), fen: @chess_kit.to_fen })

      Interface::Output::Visualizer.display_game(@chess_kit)
    end
  end

  def current_player
    Player.from_color(self, @chess_kit.current_color_name)
  end

  def config_computer_chess_engine
    return unless [@white_player, @black_player].any? { |player| player.type == :computer }

    @stockfish_engine = StockfishEngine.new
  end
end
