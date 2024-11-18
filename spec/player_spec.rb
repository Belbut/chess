# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/interface'

describe Player do
  describe '#name' do
    subject(:player) { described_class.new(interface_dbl) }
    let(:interface_dbl) { class_double(Interface, prompt_for_name: 'John') }

    it 'returns player name' do
      expect(player.name).to eq('John')
    end
  end
end
