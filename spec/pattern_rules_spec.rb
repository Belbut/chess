require_relative '../lib/rules/movement_pattern/pattern_rules'

# frozen_string_literal: true

describe PatternRules do
  subject(:pattern_rules) { described_class.new(pattern_dbl, requirement_dbl) }
  let(:pattern_dbl) { double('pattern') }
  # let(:requirement_dbl) { class_double(Requirement) }

  describe '#pattern' do
    it '' do
      expect(true).to eq(true)
    end
  end

  describe '#requirement' do
    it '' do
      # expect(move_pattern.requirement).to be_a(Requirement)
    end
  end
end
