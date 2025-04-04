# frozen_string_literal: true

class Player
  attr_reader :color, :name, :type

  def initialize(color)
    @color = color
    @name = Interface::Input.prompt_for_name(color)
    @type = @name.upcase == 'AI' ? :computer : :human
  end

  def self.name_from_color(game, color)
    case color
    when :white
      game.white_player.name
    when :black
      game.black_player.name
    end
  end

  def self.from_color(game, color)
    case color
    when :white
      game.white_player
    when :w
      game.white_player
    when :black
      game.black_player
    when :b
      game.black_player
    end
  end
end
