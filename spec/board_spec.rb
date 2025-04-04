# frozen_string_literal: true

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/coordinate'

require_relative './testing_util_spec'

RSpec::Matchers.define_negated_matcher :not_change, :change

KNOWN_BOARD = [%w[A1 B1 C1 D1 E1],
               %w[A2 B2 C2 D2 E2],
               %w[A3 B3 C3 D3 E3],
               %w[A4 B4 C4 D4 E4],
               %w[A5 B5 C5 D5 E5]].freeze

describe Board do
  include TestingUtil
  subject(:empty_board) { described_class.new(height, width) }
  let(:height) { 11 }
  let(:width) { 11 }

  subject(:known_board) { described_class.new(5, 5) }
  before do
    known_board.matrix.each_with_index do |row, row_i|
      row.each_with_index do |_cell, column_i|
        known_board.add_to_cell_content(Coordinate.new(column_i, row_i), KNOWN_BOARD[row_i][column_i])
      end
    end
  end

  let(:all_matrix_except) do
    lambda { |board, coord|
      initial_matrix = board.matrix.map(&:dup)

      initial_matrix[coord.y].delete_at(coord.x)
      initial_matrix
    }
  end

  let(:coord_A1) { instance_double(Coordinate, x: 0, y: 0) }
  let(:coord_B4) { instance_double(Coordinate, x: 1, y: 3) }
  let(:coord_D4) { instance_double(Coordinate, x: 3, y: 3) }
  let(:coord_E5) { instance_double(Coordinate, x: 4, y: 4) }

  describe '#matrix' do
    it 'is expected to be a 2 dimensional Array' do
      expect(empty_board.matrix).to be_a(Array)

      empty_board.matrix.each do |column|
        expect(column).to be_a(Array)
      end
    end
  end

  describe '#to_s' do
    it '' do
      puts empty_board
    end
  end

  describe '#check_coord' do
    context 'when checking a VALID cell ' do
      it '' do
        expect(known_board.check_coord(coord_A1)).to be nil
      end
    end

    context 'when checking a INVALID cell ' do
      context 'should raise a Error when' do
        context ' the argument doesn\'t act has a coordinate' do
          let(:invalid_coord1) { double('random argument') }
          let(:invalid_coord2) { instance_double(Coordinate, x: 'a', y: 'b') }
          it '' do
            expect { known_board.check_coord(invalid_coord1) }.to raise_error(ArgumentError)
            expect { known_board.check_coord(invalid_coord2) }.to raise_error(ArgumentError)
          end
        end

        context ' the coordinate points to outside of the known_board' do
          let(:outbound_coord1) { instance_double(Coordinate, x: 42, y: 42) }
          let(:outbound_coord2) { instance_double(Coordinate, x: 1, y: 42) }
          let(:outbound_coord3) { instance_double(Coordinate, x: 42, y: 1) }
          let(:outbound_coord4) { instance_double(Coordinate, x: -2, y: -2) }
          let(:outbound_coord5) { instance_double(Coordinate, x: 5, y: 5) }
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

  describe '#lookup_cell_content' do
    context 'when checking a cell ' do
      it 'is expected to check if the coordinate is valid' do
        expect(known_board).to receive(:check_coord).and_return(nil)
        known_board.lookup_cell_content(coord_A1)
      end

      it 'is expected to return the object on the board cell' do
        expect(known_board.lookup_cell_content(coord_A1)).to eq 'A1'
        expect(known_board.lookup_cell_content(coord_B4)).to eq 'B4'
        expect(known_board.lookup_cell_content(coord_D4)).to eq 'D4'
        expect(known_board.lookup_cell_content(coord_E5)).to eq 'E5'
      end
    end
  end

  describe '#find_position_of' do
    context 'when checking a object' do
      it 'is expected to return nil if the object is not on the board' do
        expect(known_board.find_position_of(:not_on_the_board)).to eq nil
      end

      it 'is expected to return an array of position' do
        expect(known_board.find_position_of('A1').to_notation).to eq 'A1'
        expect(known_board.find_position_of('B4').to_notation).to eq 'B4'
        expect(known_board.find_position_of('E5').to_notation).to eq 'E5'
      end
    end
  end

  describe '#find_all_positions_of' do
    BOARD41 = [%w[41 B1 C1 D1 E1],
               %w[A2 B2 C2 D2 E2],
               %w[41 B3 41 D3 E3],
               %w[A4 41 C4 D4 E4],
               %w[41 B5 C5 D5 41]].freeze

    before do
      allow(known_board).to receive(:contents).and_return BOARD41
    end
    context 'when checking a object' do
      it 'is expected to return nil if the object is not on the board' do
        expect(known_board.find_all_positions_of(:not_on_the_board)).to eq []
      end

      it 'is expected to return an array of position' do
        expect(known_board.find_all_positions_of('41').map(&:to_notation)).to eq %w[A1 A3 C3 B4 A5 E5]
      end
    end
  end

  describe '#add_to_cell_content' do
    let(:rand_obj) { double('random_object') }

    context 'when targeting a empty cell' do
      it 'is expected to add one object to the cell selected' do
        expect { empty_board.add_to_cell_content(coord_A1, rand_obj) }
          .to change { empty_board.lookup_cell_content(coord_A1) }.from(nil).to(rand_obj)
      end

      it 'is expected not to change any other cell' do
        expect { empty_board.add_to_cell_content(coord_A1, rand_obj) }
          .to(not_change { all_matrix_except.call(empty_board, coord_A1) })
      end

      it 'when doing multiples additions in a roll' do
        expect { empty_board.add_to_cell_content(coord_A1, rand_obj) }
          .to change { empty_board.lookup_cell_content(coord_A1) }.from(nil).to(rand_obj)
          .and(not_change { all_matrix_except.call(empty_board, coord_A1) })

        expect { empty_board.add_to_cell_content(coord_B4, rand_obj) }
          .to change { empty_board.lookup_cell_content(coord_B4) }.from(nil).to(rand_obj)
          .and(not_change { all_matrix_except.call(empty_board, coord_B4) })

        expect { empty_board.add_to_cell_content(coord_D4, rand_obj) }
          .to change { empty_board.lookup_cell_content(coord_D4) }.from(nil).to(rand_obj)
          .and(not_change { all_matrix_except.call(empty_board, coord_D4) })
      end
    end
  end

  describe '#clear_cell' do
    context 'when targeting a occupied cell' do
      context 'cell on diagonal' do
        let(:cell_coord) { coord_A1 }
        let!(:cell_content) { known_board.lookup_cell_content(cell_coord) }

        it 'is expected to change cell content to nil' do
          expect { known_board.clear_cell(cell_coord) }
            .to(change { known_board.lookup_cell_content(cell_coord) }.from(cell_content).to(nil))
        end

        it 'is expected not to change any other cell content' do
          expect { known_board.clear_cell(cell_coord) }
            .to(not_change { all_matrix_except.call(known_board, cell_coord) })
        end

        it 'it returns the content of the cell that was deleted' do
          expect(known_board.clear_cell(cell_coord)).to eq cell_content
        end
      end

      context 'cell not on diagonal' do
        let(:cell_coord) { coord_B4 }
        let!(:cell_content) { known_board.lookup_cell_content(cell_coord) }

        it 'is expected to change cell content to nil' do
          expect { known_board.clear_cell(cell_coord) }
            .to(change { known_board.lookup_cell_content(cell_coord) }.from(cell_content).to(nil))
        end

        it 'is expected not to change any other cell content' do
          expect { known_board.clear_cell(cell_coord) }
            .to(not_change { all_matrix_except.call(known_board, cell_coord) })
        end

        it 'it returns the content of the cell that was deleted' do
          expect(known_board.clear_cell(cell_coord)).to eq cell_content
        end
      end
    end

    context 'when targeting a empty cell' do
      let(:cell_coord) { coord_A1 }
      let!(:cell_content) { empty_board.lookup_cell_content(cell_coord) }

      it 'is expected to keep cell nil' do
        expect { empty_board.clear_cell(cell_coord) }
          .to(not_change { empty_board.lookup_cell_content(cell_coord) })
      end

      it 'is expected not to change any other cell' do
        expect { empty_board.clear_cell(cell_coord) }
          .to(not_change { all_matrix_except.call(empty_board, cell_coord) })
      end

      it 'is expected to return nil' do
        expect(empty_board.clear_cell(cell_coord)).to eq nil
      end
    end
  end
end
