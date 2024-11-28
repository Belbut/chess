# frozen_string_literal: true

require_relative '../lib/chess_kit/coordinate'
describe Coordinate do
  let(:array_position_A1) { [0, 0] }
  let(:notation_position_A1) { 'A1' }
  let(:coordinate_A1) { Coordinate.new(0, 0) }

  let(:array_position_C3) { [2, 2] }
  let(:notation_position_C3) { 'C3' }
  let(:coordinate_C3) { Coordinate.new(2, 2) }

  let(:array_position_Z23) { [25, 23] }
  let(:notation_position_Z23) { 'Z23' }
  let(:coordinate_Z23) { Coordinate.new(25, 23) }

  let(:all_coordinates) do
    { array_position_A1: coordinate_A1, array_position_C3: coordinate_C3, array_position_Z23: coordinate_Z23,
      notation_position_A1: coordinate_A1, notation_position_C3: coordinate_C3, notation_position_Z23: coordinate_Z23 }
  end

  describe '.from_array' do
    context 'when the argument is in a valid notation' do
      let(:all_array_positions) do
        { array_position_A1: array_position_A1, array_position_C3: array_position_C3,
          array_position_Z23: array_position_Z23 }
      end

      it 'is expected to return a Coordinate' do
        all_array_positions.each_value do |position|
          expect(Coordinate.from_array(position)).to be_a(Coordinate)
        end
      end

      it 'is expected to have correct x and y values' do
        all_array_positions.each_key do |array_position_key|
          position = all_array_positions[array_position_key]
          coordinate = all_coordinates[array_position_key]

          expect(Coordinate.from_array(position)).eql?(coordinate)
        end
      end
    end
    context 'when the argument is in a invalid notation' do
      let(:invalid_array_position1) { [1, 2, 3] }
      let(:invalid_array_position2) { [1] }
      let(:invalid_array_position3) { ['A', 2] }

      it '' do
        expect { Coordinate.from_array(invalid_array_position1) }.to raise_error(ArgumentError)
        expect { Coordinate.from_array(invalid_array_position2) }.to raise_error(ArgumentError)
        expect { Coordinate.from_array(invalid_array_position3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.from_notation' do
    context 'when the argument is in a valid notation' do
      let(:all_notation_positions) do
        { notation_position_A1: notation_position_A1, notation_position_C3: notation_position_C3,
          notation_position_Z23: notation_position_Z23 }
      end
      it 'is expected to return a Coordinate' do
        all_notation_positions.each_value do |position|
          expect(Coordinate.from_notation(position)).to be_a(Coordinate)
        end
      end

      it 'is expected to have correct x and y values' do
        all_notation_positions.each_key do |notation_position_key|
          position = all_notation_positions[notation_position_key]
          coordinate = all_coordinates[notation_position_key]

          expect(Coordinate.from_notation(position)).eql?(coordinate)
        end
      end
    end
    context 'when the argument is in a invalid notation' do
      let(:invalid_notation_position1) { 'AA2' }
      let(:invalid_notation_position2) { 'a0' }
      let(:invalid_notation_position3) { 'AB' }

      it '' do
        expect { Coordinate.from_notation(invalid_notation_position1) }.to raise_error(ArgumentError)
        expect { Coordinate.from_notation(invalid_notation_position2) }.to raise_error(ArgumentError)
        expect { Coordinate.from_notation(invalid_notation_position3) }.to raise_error(ArgumentError)
      end
    end
  end
end
