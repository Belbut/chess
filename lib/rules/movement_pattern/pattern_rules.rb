class PatternRules
  attr_reader :pattern, :requirements

  def initialize(pattern, *requirements)
    @pattern = pattern # [array]
    @requirements = requirements
  end
end
