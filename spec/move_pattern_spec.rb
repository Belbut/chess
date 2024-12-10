require_relative '../lib/rules/movement_pattern/move_pattern'

# frozen_string_literal: true

describe MovePattern do
  subject(:move_pattern) { described_class.new(pattern_dbl, requirement_dbl) }
  let(:pattern_dbl) { double('pattern') }
  let(:requirement_dbl) { class_double(Requirement) }

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
