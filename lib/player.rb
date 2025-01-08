# frozen_string_literal: true

class Player
  attr_reader :color, :name

  def initialize(color, interface)
    @color = color
    @name = interface.prompt_for_name
  end
end
