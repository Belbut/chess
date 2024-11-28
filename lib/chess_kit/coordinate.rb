class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def inspect
    "(#{x}, #{y})c"
  end

  def self.from_array(array_notation)
    unless array_notation.size == 2
      raise ArgumentError,
            "Invalid notation: '#{array_notation}'. Must have exactly two elements"
    end
    unless array_notation.all?(Integer)
      raise ArgumentError,
            "Invalid notation: '#{array_notation}'. Elements must be integers"
    end

    x, y = array_notation

    new(x, y)
  end

  def self.from_string(string_notation)
    column_letter = string_notation.upcase.scan(/[A-Z]/)
    row_number = string_notation.scan(/\d/).join.to_i

    unless column_letter.size == 1 && row_number.positive?
      raise ArgumentError,
            "Invalid notation: '#{string_notation}'. Must contain exactly one letter and a number."
    end

    x = ('A'..'Z').find_index(column_letter.first)
    y = row_number - 1

    new(x, y)
  end
end
