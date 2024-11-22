# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/coordinate'

KNOWN_BOARD = [%w[A1 A2 A3 A4 A5],
               %w[B1 B2 B3 B4 B5],
               %w[C1 C2 C3 C4 C5],
               %w[D1 D2 D3 D4 D5],
               %w[E1 E2 E3 E4 E5]].freeze

describe Board do
  subject(:board) { described_class.new(height, width) }
  let(:height) { 42 }
  let(:width) { 42 }

  describe '#tiles' do
    it 'is expected to be a 2 dimensional Array' do
      expect(board.tiles).to be_a(Array)

      board.tiles.each do |column|
        expect(column).to be_a(Array)
      end
    end
  end

  describe '#lookup_tile' do
    let(:coord_A1) { instance_double(Coordinate, x: 0, y: 0) }
    let(:coord_B4) { instance_double(Coordinate, x: 1, y: 3) }
    let(:coord_D4) { instance_double(Coordinate, x: 3, y: 3) }
    let(:coord_E5) { instance_double(Coordinate, x: 4, y: 4) }

    let(:outbound_coord1) { instance_double(Coordinate, x: 42, y: 42) }
    let(:outbound_coord2) { instance_double(Coordinate, x: 1, y: 42) }
    let(:outbound_coord3) { instance_double(Coordinate, x: 42, y: 1) }
    let(:outbound_coord4) { instance_double(Coordinate, x: -2, y: -2) }
    let(:outbound_coord5) { instance_double(Coordinate, x: 5, y: 5) }

    let(:not_a_coord1) { double('random argument') }
    let(:not_a_coord2) { instance_double(Coordinate, x: 'a', y: 'b') }

    before do
      board.instance_variable_set(:@tiles, KNOWN_BOARD)
    end

    context 'when checking a INVALID tile ' do
      context 'should raise a Error when' do
        context ' the argument doesn\'t act has a coordinate' do
          it '' do
            expect { board.lookup_tile(not_a_coord1) }.to raise_error(ArgumentError)
            expect { board.lookup_tile(not_a_coord2) }.to raise_error(ArgumentError)
          end
        end

        context ' the coordinate points to outside of the board' do
          it '' do
            expect { board.lookup_tile(outbound_coord1) }.to raise_error(RangeError)
            expect { board.lookup_tile(outbound_coord2) }.to raise_error(RangeError)
            expect { board.lookup_tile(outbound_coord3) }.to raise_error(RangeError)
            expect { board.lookup_tile(outbound_coord4) }.to raise_error(RangeError)
            expect { board.lookup_tile(outbound_coord5) }.to raise_error(RangeError)
          end
        end
      end
    end

    context 'when checking a VALID tile ' do
      it 'is expected to return the object on the board tile' do
        expect(board.lookup_tile(coord_A1)).to eq 'A1'
        expect(board.lookup_tile(coord_B4)).to eq 'B4'
        expect(board.lookup_tile(coord_D4)).to eq 'D4'
        expect(board.lookup_tile(coord_E5)).to eq 'E5'
      end
    end
  end
end
