class Cell
  attr_accessor :content, :bg_color

  def initialize(content = nil, bg_color = nil)
    @content = content
    @bg_color = bg_color
  end

  def nil?
    @content.nil?
  end

  def ==(other)
    other.is_a?(Cell) && @content == other.content
  end

  def to_s
    @content.to_s
  end
end
