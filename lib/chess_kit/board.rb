class Board
  require_relative '../interface'

  attr_reader :cells

  def initialize(rows, columns)
    @cells = Array.new(rows) { Array.new(columns) }
  end

  def to_s
    Interface::Output.render_game(self)
  end

  def check_coord(coord)
    raise ArgumentError, "The Coordinate doesn't respond to :x , :y" unless valid_coord?(coord)
    raise RangeError, "The Coordinate isn't inside the bounds of the board" unless inside_board?(coord)
  end

  def lookup_cell(coord)
    check_coord(coord)

    cells[coord.y][coord.x]
  end

  def find_position_of(object)
    x_index = nil
    y_index = cells.index do |row|
      x_index = row.index(object)
    end

    return nil if y_index.nil?

    Coordinate.new(x_index, y_index)
  end

  def find_all_positions_of(object)
    result = []

    cells.each_with_index do |row, yy|
      row.each_with_index do |cell, xx|
        result.append(Coordinate.new(xx, yy)) if cell == object
      end
    end

    result
  end

  def add_to_cell(coord, object)
    check_coord(coord) # redundant but makes it explicit
    raise ArgumentError, "Cell already occupied at #{coord}" unless lookup_cell(coord).nil?

    cells[coord.y][coord.x] = object if lookup_cell(coord).nil?
  end

  def clear_cell(coord)
    check_coord(coord)

    old_obj = cells[coord.x][coord.y]
    cells[coord.y][coord.x] = nil

    old_obj
  end

  def board_height
    cells.size
  end

  def board_width
    cells.transpose.size
  end

  def inside_board?(coord)
    coord.x.between?(0, (board_height - 1)) && coord.y.between?(0, (board_width - 1))
  end

  private

  def valid_coord?(coord)
    coord.respond_to?(:x) && coord.respond_to?(:y)
  end
end
