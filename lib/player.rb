# frozen_string_literal: true

class Player
  attr_reader :name

  def initialize(interface)
    @name = interface.prompt_for_name
  end
end
