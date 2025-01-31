class Board
  require_relative '../interface'
  require_relative './fen'

  attr_reader :matrix

  def initialize(rows, columns, matrix = nil)
    @matrix = matrix || Array.new(rows) { Array.new(columns) }
  end

  def deep_clone
    matrix_clone = @matrix.map do |row|
      row.map(&:clone)
    end
    Board.new(nil, nil, matrix_clone)
  end

  def to_s
    Interface::Output.render_game(self)
  end

  def to_algebraic_notation
    result = ''
    @matrix.reverse.each do |row|
      row_notation = ''
      empty_in_a_row = 0
      row.each do |cell|
        if cell.nil?
          empty_in_a_row += 1
        else
          notation = FEN.piece_to_algebraic_notation(cell)
          if empty_in_a_row.positive?
            row_notation.concat(empty_in_a_row.to_s)
            empty_in_a_row = 0
          end
          row_notation.concat(notation)
        end
      end
      row_notation.concat(empty_in_a_row.to_s) if empty_in_a_row.positive?
      result.concat(row_notation, '/')
    end
    result.chop
  end

  def self.from_algebraic_notation; end

  def check_coord(coord)
    raise ArgumentError, "The Coordinate doesn't respond to :x , :y" unless valid_coord?(coord)
    raise RangeError, "The Coordinate isn't inside the bounds of the board" unless inside_board?(coord)
  end

  def lookup_cell(coord)
    check_coord(coord)

    matrix[coord.y][coord.x]
  end

  # refactor this into a lambda
  def find_position_of(object, strict: false)
    x_index = nil
    y_index = matrix.index do |row|
      x_index = if strict
                  row.index { |cell| object.strict_equal?(cell) }
                else
                  row.index(object)
                end
    end

    return nil if y_index.nil?

    Coordinate.new(x_index, y_index)
  end

  def find_all_positions_of(object)
    result = []

    matrix.each_with_index do |row, yy|
      row.each_with_index do |cell, xx|
        result.append(Coordinate.new(xx, yy)) if cell == object
      end
    end

    result
  end

  def add_to_cell(coord, object)
    check_coord(coord) # redundant but makes it explicit
    raise ArgumentError, "Cell already occupied at #{coord}" unless lookup_cell(coord).nil?

    matrix[coord.y][coord.x] = object if lookup_cell(coord).nil?
  end

  def add_to_cell!(coord, object)
    check_coord(coord) # redundant but makes it explicit

    matrix[coord.y][coord.x] = object
  end

  def clear_cell(coord)
    check_coord(coord)

    old_obj = matrix[coord.y][coord.x]
    matrix[coord.y][coord.x] = nil

    old_obj
  end

  def board_height
    matrix.size
  end

  def board_width
    matrix.transpose.size
  end

  def inside_board?(coord)
    coord.x.between?(0, (board_height - 1)) && coord.y.between?(0, (board_width - 1))
  end

  private

  def valid_coord?(coord)
    coord.respond_to?(:x) && coord.respond_to?(:y)
  end
end
