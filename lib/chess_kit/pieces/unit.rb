class Unit
  require_relative '../../interface'

  attr_reader :color, :type, :move_status

  def initialize(color, type)
    @color = color
    @type = type
    @move_status = :unmoved
  end

  def to_s
    Interface::Output::Visualizer.render_piece(self)
  end

  def ==(other)
    self.class == other.class && color == other.color && type == other.type
  end

  def strict_equal?(other)
    self == other && move_status == other.move_status
  end

  def mark_as_moved
    @move_status = :moved
  end

  def unmoved?
    @move_status == :unmoved
  end

  def black?
    @color == :black
  end

  def white?
    @color == :white
  end
end
