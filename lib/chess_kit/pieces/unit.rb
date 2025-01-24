class Unit
  require_relative '../../interface'

  attr_reader :color, :type, :move_status

  def initialize(color, type)
    @color = color
    @type = type
    @move_status = :unmoved
  end

  def to_s
    Interface::Output.render_piece(self)
  end

  def ==(other)
    color == other.color && type == other.type
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
