# frozen_string_literal: true

class Player
  attr_reader :color, :name

  def initialize(color)
    @color = color
    @name = Interface.prompt_for_name(color)
  end
end
