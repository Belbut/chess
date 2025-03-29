# frozen_string_literal: true

class Player
  attr_reader :color, :name

  def initialize(color)
    @color = color
    @name = Interface.prompt_for_name(color)
  end

  def self.name_from_color(game, color)
    case color
    when :white
      game.white_player.name
    when :black
      game.black_player.name
    end
  end
end
