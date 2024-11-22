class Board
  attr_reader :tiles

  def initialize(rows, columns)
    @tiles = Array.new(rows) { Array.new(columns) }
  end

  def lookup_tile(coord)
    raise ArgumentError unless valid_coord?(coord)
    raise RangeError unless inside_board?(coord)

    @tiles[coord.x][coord.y]
  end

  private

  def valid_coord?(coord)
    coord.respond_to?(:x) && coord.respond_to?(:y)
  end

  def inside_board?(coord)
    coord.x.between?(0, (board_height - 1)) && coord.y.between?(0, (board_width - 1))
  end

  def board_height
    @tiles.size
  end

  def board_width
    @tiles.first.size
  end
end
