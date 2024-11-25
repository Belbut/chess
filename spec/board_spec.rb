# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/coordinate'

KNOWN_BOARD = [%w[A1 A2 A3 A4 A5],
               %w[B1 B2 B3 B4 B5],
               %w[C1 C2 C3 C4 C5],
               %w[D1 D2 D3 D4 D5],
               %w[E1 E2 E3 E4 E5]].freeze

describe Board do
  subject(:empty_board) { described_class.new(height, width) }
  let(:height) { 42 }
  let(:width) { 42 }

  subject(:known_board) { described_class.new(5, 5) }
  before do
    known_board.instance_variable_set(:@tiles, KNOWN_BOARD)
  end

  let(:coord_A1) { instance_double(Coordinate, x: 0, y: 0) }
  let(:coord_B4) { instance_double(Coordinate, x: 1, y: 3) }
  let(:coord_D4) { instance_double(Coordinate, x: 3, y: 3) }
  let(:coord_E5) { instance_double(Coordinate, x: 4, y: 4) }

  describe '#tiles' do
    it 'is expected to be a 2 dimensional Array' do
      expect(empty_board.tiles).to be_a(Array)

      empty_board.tiles.each do |column|
        expect(column).to be_a(Array)
      end
    end
  end

  describe '#check_coord' do
    let(:outbound_coord1) { instance_double(Coordinate, x: 42, y: 42) }
    let(:outbound_coord2) { instance_double(Coordinate, x: 1, y: 42) }
    let(:outbound_coord3) { instance_double(Coordinate, x: 42, y: 1) }
    let(:outbound_coord4) { instance_double(Coordinate, x: -2, y: -2) }
    let(:outbound_coord5) { instance_double(Coordinate, x: 5, y: 5) }

    let(:not_a_coord1) { double('random argument') }
    let(:not_a_coord2) { instance_double(Coordinate, x: 'a', y: 'b') }
    context 'when checking a VALID tile ' do
      it '' do
        expect(known_board.check_coord(coord_A1)).to be nil
      end
    end

    context 'when checking a INVALID tile ' do
      context 'should raise a Error when' do
        context ' the argument doesn\'t act has a coordinate' do
          it '' do
            expect { known_board.check_coord(not_a_coord1) }.to raise_error(ArgumentError)
            expect { known_board.check_coord(not_a_coord2) }.to raise_error(ArgumentError)
          end
        end

        context ' the coordinate points to outside of the known_board' do
          it '' do
            expect { known_board.check_coord(outbound_coord1) }.to raise_error(RangeError)
            expect { known_board.check_coord(outbound_coord2) }.to raise_error(RangeError)
            expect { known_board.check_coord(outbound_coord3) }.to raise_error(RangeError)
            expect { known_board.check_coord(outbound_coord4) }.to raise_error(RangeError)
            expect { known_board.check_coord(outbound_coord5) }.to raise_error(RangeError)
          end
        end
      end
    end
  end

  describe '#lookup_tile' do
    context 'when checking a tile ' do
      it 'is expected to check if the coordinate is valid' do
        expect(known_board).to receive(:check_coord).and_return(nil)
        known_board.lookup_tile(coord_A1)
      end

      it 'is expected to return the object on the board tile' do
        expect(known_board.lookup_tile(coord_A1)).to eq 'A1'
        expect(known_board.lookup_tile(coord_B4)).to eq 'B4'
        expect(known_board.lookup_tile(coord_D4)).to eq 'D4'
        expect(known_board.lookup_tile(coord_E5)).to eq 'E5'
      end
    end
  end

  describe '#add_to_tile' do
    let(:rand_obj) { double('random_object') }

    let(:total_cells) { empty_board.tiles.flatten.count }
    let(:total_obj_cells) { -> { empty_board.tiles.flatten.tally[rand_obj] } }
    let(:total_empty_cells) { -> { empty_board.tiles.flatten.count(nil) } }

    context 'when targeting a empty cell' do
      it 'is expected to add one object to the tile selected' do
        expect { empty_board.add_to_tile(coord_A1, rand_obj) }.to(change { empty_board.lookup_tile(coord_A1) })
        expect(total_obj_cells.call).to eq 1
      end

      it 'is expected not to change any other tiles' do
        empty_board.add_to_tile(coord_A1, rand_obj)
        expect(total_empty_cells.call).to eq(total_cells - 1)
      end

      it 'when doing multiples additions in a roll' do
        empty_board.add_to_tile(coord_A1, rand_obj)
        expect(total_obj_cells.call).to eq(1)
        expect(total_empty_cells.call).to eq(total_cells - 1)

        empty_board.add_to_tile(coord_B4, rand_obj)
        expect(total_obj_cells.call).to eq(2)
        expect(total_empty_cells.call).to eq(total_cells - 2)

        empty_board.add_to_tile(coord_D4, rand_obj)
        expect(total_obj_cells.call).to eq(3)
        expect(total_empty_cells.call).to eq(total_cells - 3)
      end
    end
  end
end
