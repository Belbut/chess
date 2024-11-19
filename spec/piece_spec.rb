# frozen_string_literal: true

require_relative '../lib/chess_kit/piece'

describe Piece do
  subject(:new_piece) { described_class.new(color_dbl) }
  let(:color_dbl) { double('random color') }

  describe '#color' do
    subject(:white_piece) { described_class.new(:white) }
    subject(:black_piece) { described_class.new(:black) }
    it 'is expected to return the correct piece color' do
      expect(white_piece.color).to eq(:white)
      expect(black_piece.color).to eq(:black)
    end
  end
  describe '#move_status' do
    context 'for a general piece' do
      context 'when the piece hasn\'t been moved' do
        it 'is expected to return :unmoved' do
          expect(new_piece.move_status).to eq(:unmoved)
        end
      end
      context 'when the piece has made some moves' do
        let(:moved_piece) { new_piece }
        before do
          moved_piece.instance_variable_set(:@moves_number, rand(20))
        end

        it 'is expected to return :moved' do
          expect(moved_piece.move_status).to eq(:moved)
        end
      end
    end
  end
end
