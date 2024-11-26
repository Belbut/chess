class Board
  attr_reader :cells

  def initialize(rows, columns)
    @cells = Array.new(rows) { Array.new(columns) }
  end

  def check_coord(coord)
    raise ArgumentError, "The Coordinate doesn't respond to :x , :y" unless valid_coord?(coord)
    raise RangeError, "The Coordinate isn't inside the bounds of the board" unless inside_board?(coord)
  end

  def lookup_cell(coord)
    check_coord(coord)

    @cells[coord.x][coord.y]
  end

  def add_to_cell(coord, object)
    check_coord(coord) # redundant but makes it explicit
    raise ArgumentError, "Cell already occupied at #{coord}" unless lookup_cell(coord).nil?

    @cells[coord.x][coord.y] = object if lookup_cell(coord).nil?
  end

  def clear_cell(coord)
    check_coord(coord)

    old_obj = @cells[coord.x][coord.y]
    @cells[coord.x][coord.y] = nil

    old_obj
  end

  private

  def valid_coord?(coord)
    coord.respond_to?(:x) && coord.respond_to?(:y)
  end

  def inside_board?(coord)
    coord.x.between?(0, (board_height - 1)) && coord.y.between?(0, (board_width - 1))
  end

  def board_height
    @cells.size
  end

  def board_width
    @cells.first.size
  end
end
