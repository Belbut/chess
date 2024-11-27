# frozen_string_literal: true

require_relative './unit'
module Pieces
  class Rook < Unit
    def initialize(color)
      type = :rook

      super(color, type)
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
