# frozen_string_literal: true

require_relative '../lib/chess_kit'

describe ChessKit do
  context 'a chess kit is made of' do
    subject(:chess_kit) { described_class.new }
    context 'one board' do
      let(:empty_board) { chess_kit.board }
      context 'a empty board' do
        it 'is expected to be a 8x8 matrix' do
          height = empty_board.size
          width = empty_board.first.size
          expect(height).to eq 8
          expect(width).to eq 8
        end
      end
    end

    describe '#' do
    end
  end
end
