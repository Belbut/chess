# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/interface'

describe Player do
  subject(:player) { described_class.new(:player_color, interface_dbl) }
  let(:interface_dbl) { double }

  before do
    allow(interface_dbl).to receive(:prompt_for_name)
  end

  describe '#color' do
    it 'returns player color' do
      expect(player.color).to eq(:player_color)
    end
  end

  describe '#name' do
    before do
      allow(interface_dbl).to receive(:prompt_for_name).and_return('John')
    end
    it 'returns player name' do
      expect(player.name).to eq('John')
    end
  end
end
