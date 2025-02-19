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

  def ==(other)
    matrix == other.matrix
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

  def self.from_algebraic_notation(notation)
    board_decomposition = notation.split('/').reverse
    row_number = board_decomposition.size
    column_number = count_columns(board_decomposition.sample)

    board = Board.new(row_number, column_number)

    board_decomposition.each_with_index do |row_notation, row_index|
      column_pointer = 0

      row_notation.each_char do |char|
        if char.to_i.zero?
          target_coord = Coordinate.new(column_pointer, row_index)
          target_piece = FEN.algebraic_notation_to_piece(char)
          board.add_to_cell(target_coord, target_piece)
          column_pointer += 1
        else
          column_pointer += char.to_i
        end
      end
    end
    board
  end

  def self.count_rows(notation)
    notation.size
  end

  def self.count_columns(row_notation)
    n = 0
    row_notation.each_char do |char|
      n += if char.to_i.zero?
             1
           else
             char.to_i
           end
    end
    n
  end

  def check_coord(coord)
    raise ArgumentError, "The Coordinate doesn't respond to :x , :y" unless valid_coord?(coord)
    raise RangeError, "The Coordinate isn't inside the bounds of the board" unless inside_board?(coord)
  end

  def lookup_cell(coord)
    check_coord(coord)

    matrix[coord.y][coord.x]
  end

  def find_position_of(object = nil, &block)
    raise ArgumentError, 'Provide either an object or a block, not both' if object && block

    x_index = nil
    y_index = matrix.index do |row|
      x_index = block_given? ? row.index(&block) : row.index(object)
    end

    return nil if y_index.nil?

    Coordinate.new(x_index, y_index)
  end

  def find(object = nil, &block)
    raise ArgumentError, 'Provide either an object or a block, not both' if object && block_given?

    position = if object
                 find_position_of(object)
               elsif block_given?
                 find_position_of do |cell|
                   cell.is_a?(Unit) && block.call(cell)
                 end
               else
                 raise ArgumentError, 'Must provide either an object or a block'
               end
               
    lookup_cell(position) unless position.nil?
  end

  def find_all_positions_of(object = nil, &block)
    raise ArgumentError, 'Provide either an object or a block, not both' if object && block

    result = []
    matrix.each_with_index do |row, yy|
      row.each_with_index do |cell, xx|
        if block_given?
          result.append(Coordinate.new(xx, yy)) if yield(cell)
        elsif cell == object
          result.append(Coordinate.new(xx, yy))
        end
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
