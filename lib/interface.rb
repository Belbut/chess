# frozen_string_literal: true

module Interface
  module Output
    require 'rainbow'

    COLOR_PALETTE = { white: :snow, black: :black, dark: :darkslategray, light: :yellow }.freeze

    PIECE_BLUEPRINT = { pawn: " \u265F ",
                        rook: " \u265C ",
                        knight: " \u265E ",
                        bishop: " \u265D ",
                        queen: " \u265B ",
                        king: " \u265A " }.freeze

    def self.render_piece(unit)
      blueprint = PIECE_BLUEPRINT[unit.type]
      canvas = Rainbow(blueprint)
      canvas.color(COLOR_PALETTE[unit.color])
    end
  end
  extend Output
  def self.prompt_for_name; end
end
