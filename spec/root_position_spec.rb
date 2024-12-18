# frozen_string_literal: true

require_relative '../lib/rules/movement_pattern/root_position'
require_relative '../lib/chess_kit/coordinate'
require_relative '../lib/rules/movement_pattern/move_pattern'
require_relative '../lib/rules/movement_pattern/move_position_node'

describe RootPosition do
  let(:coord_A1) { instance_double(Coordinate, x: 0, y: 0) }
  let(:coord_B4) { instance_double(Coordinate, x: 1, y: 3) }
  let(:coord_D4) { instance_double(Coordinate, x: 3, y: 3) }
  let(:coord_E5) { instance_double(Coordinate, x: 4, y: 4) }

  subject(:root_position) { described_class.new(coord_dbl, movement_pattern_dbl) }
  let(:coord_dbl) { coord_A1 }
  let(:movement_pattern_dbl) { instance_double(MovePattern) }

  describe '#coordinate' do
    it '' do
      expect(true).to eq(true)
    end
  end

  describe '#movement_pattern' do
    it '' do
      expect(true).to eq(true)
    end
  end

  describe '#child_move_nodes' do
    it '' do
      allow(movement_pattern_dbl).to receive(:pattern).and_return([])

      expect(root_position.child_move_nodes).to be_a(Array)
    end

    context 'when testing a orthogonal movement pattern' do
      let(:orthogonals_movement_pattern_dbl) { movement_pattern_dbl }
      before do
        allow(orthogonals_movement_pattern_dbl).to receive(:pattern).and_return([[:n, 0], [0, :n]])
        allow(orthogonals_movement_pattern_dbl).to receive(:requirement).and_return(true)
      end

      subject(:root_position) { described_class.new(coord_dbl, orthogonals_movement_pattern_dbl) }

      it 'the @child_move_nodes is expected to be a kind of MovePositionNode' do
        root_position.child_move_nodes.each do |child_move_node|
          expect(child_move_node).to be_a(MovePositionNode)
        end
      end
      context 'when there is no requirements restrictions' do
        it 'is expected to have 4 possible child move nodes' do
          expect(root_position.child_move_nodes.size).to eq(4)
        end

        context 'were the coordinates are expected to be' do
          subject(:root_position_A1) { described_class.new(coord_A1, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_A1.child_move_nodes.map(&:coordinate)
            expected_coordinates = [[1, 0], [-1, 0], [0, 1], [0, -1]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_B4) { described_class.new(coord_B4, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_B4.child_move_nodes.map(&:coordinate)
            expected_coordinates = [[2, 3], [0, 3], [1, 4], [1, 2]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_D4) { described_class.new(coord_D4, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_D4.child_move_nodes.map(&:coordinate)
            expected_coordinates = [[4, 3], [2, 3], [3, 4], [3, 2]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_E5) { described_class.new(coord_E5, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_E5.child_move_nodes.map(&:coordinate)
            expected_coordinates = [[5, 4], [3, 4], [4, 5], [4, 3]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end
        end
      end
    end
  end

  # allow(:diagonals_movement_pattern).to receive(:pattern).and_return([%i[n n], %i[n nn]])
  # allow(:diagonals_movement_pattern).to receive(:requirement).and_return(true)

  # allow(:omnidirectional_movement_pattern).to receive(:pattern).and_return([[:n, 0], [0, :n], %i[n n], %i[n nn]])
  # allow(:omnidirectional_movement_pattern).to receive(:requirement).and_return(true)

  # allow(:short_movement_pattern_L).to receive(:pattern).and_return([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
  #                                                                   [-1, +2], [-1, -2], [-2, 1], [-2, -1]])
  # allow(:short_movement_pattern_L).to receive(:requirement).and_return(true)
end