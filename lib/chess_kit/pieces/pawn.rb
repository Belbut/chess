require_relative './unit'

module Pieces
  class Pawn < Unit
    def initialize(color)
      type = :pawn

      super(color, type)
    end

    def mark_as_rushed
      raise StandardError, 'This pawn was already moved before' if @move_status == :moved

      @move_status = :rushed
    end
  end
end
