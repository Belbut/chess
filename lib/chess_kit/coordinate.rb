class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def inspect
    "(#{x}, #{y})c"
  end

  def self.from_array(position)
    unless position.size == 2
      raise ArgumentError,
            "Invalid notation: '#{position}'. Must have exactly two elements"
    end
    unless position.all?(Integer)
      raise ArgumentError,
            "Invalid notation: '#{position}'. Elements must be integers"
    end

    x, y = position

    new(x, y)
  end

  def self.from_notation(position)
    column_letter = position.upcase.scan(/[A-Z]/)
    row_number = position.scan(/\d/).join.to_i

    unless column_letter.size == 1 && row_number.positive?
      raise ArgumentError,
            "Invalid notation: '#{position}'. Must contain exactly one letter and a number."
    end

    x = ('A'..'Z').find_index(column_letter.first)
    y = row_number - 1

    new(x, y)
  end
end
