class Cell
  attr_accessor :content, :state

  def initialize(content = nil, state = nil)
    @content = content
    @state = state
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

  def reset_state
    @state = nil
  end
end
