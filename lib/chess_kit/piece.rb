class Piece
  attr_reader :color

  PIECE_STATUS = Hash.new(:moved)

  def initialize(color)
    @color = color
    @moves_number = 0
  end

  def move_status
    if @moves_number.zero?
      :unmoved
    else
      :moved
    end
  end
end
