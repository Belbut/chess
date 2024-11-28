# frozen_string_literal: true

require_relative '../lib/chess_kit/coordinate'
describe Coordinate do
  let(:array_notation_A1) { [0, 0] }
  let(:string_notation_A1) { 'A1' }
  let(:coordinate_A1) { Coordinate.new(0, 0) }

  let(:array_notation_C3) { [2, 2] }
  let(:string_notation_C3) { 'C3' }
  let(:coordinate_C3) { Coordinate.new(2, 2) }

  let(:array_notation_Z23) { [25, 23] }
  let(:string_notation_Z23) { 'Z23' }
  let(:coordinate_Z23) { Coordinate.new(25, 23) }

  let(:all_coordinates) do
    { array_notation_A1: coordinate_A1, array_notation_C3: coordinate_C3, array_notation_Z23: coordinate_Z23,
      string_notation_A1: coordinate_A1, string_notation_C3: coordinate_C3, string_notation_Z23: coordinate_Z23 }
  end

  describe '.from_array' do
    context 'when the argument is in a valid notation' do
      let(:all_array_notations) do
        { array_notation_A1: array_notation_A1, array_notation_C3: array_notation_C3,
          array_notation_Z23: array_notation_Z23 }
      end

      it 'is expected to return a Coordinate' do
        all_array_notations.each_value do |position|
          expect(Coordinate.from_array(position)).to be_a(Coordinate)
        end
      end

      it 'is expected to have correct x and y values' do
        all_array_notations.each_key do |array_notation_key|
          position = all_array_notations[array_notation_key]
          coordinate = all_coordinates[array_notation_key]

          expect(Coordinate.from_array(position)).eql?(coordinate)
        end
      end
    end
    context 'when the argument is in a invalid notation' do
      let(:invalid_array_notation1) { [1, 2, 3] }
      let(:invalid_array_notation2) { [1] }
      let(:invalid_array_notation3) { ['A', 2] }

      it '' do
        expect { Coordinate.from_array(invalid_array_notation1) }.to raise_error(ArgumentError)
        expect { Coordinate.from_array(invalid_array_notation2) }.to raise_error(ArgumentError)
        expect { Coordinate.from_array(invalid_array_notation3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.from_string' do
    context 'when the argument is in a valid notation' do
      let(:all_string_notations) do
        { string_notation_A1: string_notation_A1, string_notation_C3: string_notation_C3,
          string_notation_Z23: string_notation_Z23 }
      end
      it 'is expected to return a Coordinate' do
        all_string_notations.each_value do |position|
          expect(Coordinate.from_string(position)).to be_a(Coordinate)
        end
      end

      it 'is expected to have correct x and y values' do
        all_string_notations.each_key do |string_notation_key|
          position = all_string_notations[string_notation_key]
          coordinate = all_coordinates[string_notation_key]

          expect(Coordinate.from_string(position)).eql?(coordinate)
        end
      end
    end
    context 'when the argument is in a invalid notation' do
      let(:invalid_string_notation1) { 'AA2' }
      let(:invalid_string_notation2) { 'a0' }
      let(:invalid_string_notation3) { 'AB' }

      it '' do
        expect { Coordinate.from_string(invalid_string_notation1) }.to raise_error(ArgumentError)
        expect { Coordinate.from_string(invalid_string_notation2) }.to raise_error(ArgumentError)
        expect { Coordinate.from_string(invalid_string_notation3) }.to raise_error(ArgumentError)
      end
    end
  end
end
