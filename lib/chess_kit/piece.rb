module ChessPiece

  class Unit
    require_relative '../rules/move_patterns'

    attr_reader :color, :type, :move_pattern, :capture_pattern, :move_status


    def initialize(color, type)
      @color = color
      @type = type
      @move_pattern = MovePattern::MOVE_FACTORY[type]
      @capture_pattern = @move_pattern
      @move_status = :unmoved
    end

    def mark_as_moved
      @move_status = :moved
    end
  end

    class Pawn < Unit
      def initialize(color)
        type = :pawn

        super(color,type)
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
        raise Exception.new 'This pawn was already moved before' if @move_status == :moved

        @move_status = :rushed
      end
    end

    class Rook < Unit
      def initialize(color)
        type = :rook

        super(color,type)
      end
    end

    class Knight < Unit
      def initialize(color)
        type = :knight

        super(color, type)
      end
    end

    class Bishop < Unit
      def initialize(color)
        type = :bishop
      
        super(color, type)
      end
    end

    class Queen < Unit
      def initialize(color)
        type = :queen
        
        super(color, type)
      end
    end

    class King < Unit
      def initialize(color)
        type = :king
        
        super(color, type)
      end
    end
  end
