class Board
  attr_reader :tiles

  def initialize(rows, columns)
    @tiles = Array.new(rows) { Array.new(columns) }
  end

  def lookup_tile(coord)
    check_coord(coord)

    @tiles[coord.x][coord.y]
  end

  def add_to_tile(coord, object)
    check_coord(coord) # redundant but makes it explicit
    raise ArgumentError, "Tile already occupied at #{coord}" unless lookup_tile(coord).nil?

    @tiles[coord.x][coord.y] = object if lookup_tile(coord).nil?
  end

  def check_coord(coord)
    raise ArgumentError, "The Coordinate doesn't respond to :x , :y" unless valid_coord?(coord)
    raise RangeError, "The Coordinate isn't inside the bounds of the board" unless inside_board?(coord)
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
