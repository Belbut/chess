require_relative './chess_piece'

module ChessPiece
  class Pawn < Unit
    def initialize(color)
      type = :pawn

      super(color, type)
    end

    def move_pattern
      if move_status == :unmoved
        MovePattern::UNMOVED_PAWN_MOVE_PATTERN
      else
        MovePattern::MOVED_PAWN_MOVE_PATTERN
      end
    end

    def capture_pattern
      MovePattern::PAWN_CAPTURE_PATTERN
    end

    def mark_as_rushed
      raise StandardError, 'This pawn was already moved before' if @move_status == :moved

      @move_status = :rushed
    end
  end
end
