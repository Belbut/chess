class Coordinate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def inspect
    # "(#{x}, #{y})c"
    to_notation
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def <=>(other)
    to_array <=> other.to_array
  end

  def to_array
    [x, y]
  end

  def to_notation
    xx = ('A'..'Z').to_a[x]

    "#{xx}#{y + 1}"
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

  def self.distance_between(coord_i, coord_f)
    xxi = coord_i.x
    yyi = coord_i.y
    xxf = coord_f.x
    yyf = coord_f.y

    Math.sqrt((xxi - xxf)**2 + (yyi - yyf)**2)
  end
end
