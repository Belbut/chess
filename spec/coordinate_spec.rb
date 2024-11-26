# frozen_string_literal: true

require_relative '../lib/chess_kit/coordinate'
describe Coordinate do
  describe '.from_array' do
    let(:position_A1) { [0, 0] }
    let(:coordinate_A1) { Coordinate.new(0, 0) }

    let(:position_C3) { [2, 2] }
    let(:coordinate_C3) { Coordinate.new(2, 2) }

    let(:position_Z23) { [25, 23] }
    let(:coordinate_Z23) { Coordinate.new(25, 23) }

    let(:all_positions) { { position_A1: position_A1, position_C3: position_C3, position_Z23: position_Z23 } }
    let(:all_coordinates) do
      { position_A1: coordinate_A1, position_C3: coordinate_C3, position_Z23: coordinate_Z23 }
    end

    it 'is expected to return a Coordinate' do
      all_positions.each_value do |position|
        expect(Coordinate.from_array(position)).to be_a(Coordinate)
      end
    end

    it 'is expected to have correct x and y values' do
      all_positions.each_key do |position_key|
        position = all_positions[position_key]
        coordinate = all_coordinates[position_key]

        expect(Coordinate.from_array(position)).eql?(coordinate)
      end
    end
  end
end
