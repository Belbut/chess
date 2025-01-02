# frozen_string_literal: true

require_relative '../lib/rules/movement_pattern/root_position'
require_relative '../lib/chess_kit/coordinate'
require_relative '../lib/rules/movement_pattern/pattern_rules'
require_relative '../lib/rules/movement_pattern/move_position_node'

describe RootPosition do
  let(:coord_A1) { instance_double(Coordinate, x: 0, y: 0) }
  let(:coord_B4) { instance_double(Coordinate, x: 1, y: 3) }
  let(:coord_D4) { instance_double(Coordinate, x: 3, y: 3) }
  let(:coord_E5) { instance_double(Coordinate, x: 4, y: 4) }

  subject(:root_position) { described_class.new(coord_dbl, movement_pattern_dbl) }
  let(:coord_dbl) { coord_A1 }
  let(:movement_pattern_dbl) { instance_double(PatternRules, requirements: []) }

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
    before do
      allow_any_instance_of(MovePositionNode).to receive(:one_direction_child_move_node).and_return(nil)
    end

    it '' do
      allow(movement_pattern_dbl).to receive(:pattern).and_return([])
      expect(root_position.child_move_nodes).to be_a(Array)
    end

    context 'when testing a orthogonal movement pattern' do
      let(:orthogonals_movement_pattern_dbl) { movement_pattern_dbl }
      before do
        allow(orthogonals_movement_pattern_dbl).to receive(:pattern).and_return([[:n, 0], [0, :n]])
      end

      subject(:root_position) { described_class.new(coord_dbl, orthogonals_movement_pattern_dbl) }

      it 'the @child_move_nodes is expected to be a kind of MovePositionNode' do
        root_position.child_move_nodes.each do |child_move_node|
          expect(child_move_node).to be_a(MovePositionNode)
        end
      end

      context 'when there is no requirements restrictions' do
        before do
          allow(MovementUtil).to receive(:comply_with_restrictions).and_return(true)
        end

        it 'is expected to have 4 possible child move nodes' do
          expect(root_position.child_move_nodes.size).to eq(4)
        end

        context 'were the coordinates are expected to be' do
          subject(:root_position_A1) { described_class.new(coord_A1, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_A1.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[1, 0], [-1, 0], [0, 1], [0, -1]]
            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_B4) { described_class.new(coord_B4, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_B4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[2, 3], [0, 3], [1, 4], [1, 2]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_D4) { described_class.new(coord_D4, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_D4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[4, 3], [2, 3], [3, 4], [3, 2]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_E5) { described_class.new(coord_E5, orthogonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_E5.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[5, 4], [3, 4], [4, 5], [4, 3]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end
        end
      end
    end

    context 'when testing a diagonal movement pattern' do
      let(:diagonals_movement_pattern_dbl) { movement_pattern_dbl }

      before do
        allow(diagonals_movement_pattern_dbl).to receive(:pattern).and_return([%i[n n], %i[n nn]])
      end

      subject(:root_position) { described_class.new(coord_dbl, diagonals_movement_pattern_dbl) }

      it 'the @child_move_nodes is expected to be a kind of MovePositionNode' do
        root_position.child_move_nodes.each do |child_move_node|
          expect(child_move_node).to be_a(MovePositionNode)
        end
      end

      context 'when there is no requirements restrictions' do
        before do
          allow(MovementUtil).to receive(:comply_with_restrictions).and_return(true)
        end

        it 'is expected to have 4 possible child move nodes' do
          expect(root_position.child_move_nodes.size).to eq(4)
        end

        context 'were the coordinates are expected to be' do
          subject(:root_position_A1) { described_class.new(coord_A1, diagonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_A1.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_B4) { described_class.new(coord_B4, diagonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_B4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[0, 2], [0, 4], [2, 2], [2, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_D4) { described_class.new(coord_D4, diagonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_D4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[2, 2], [2, 4], [4, 2], [4, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_E5) { described_class.new(coord_E5, diagonals_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_E5.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[3, 3], [3, 5], [5, 3], [5, 5]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end
        end
      end
    end

    context 'when testing a omnidirectional movement pattern' do
      let(:omnidirectional_movement_pattern_dbl) { movement_pattern_dbl }
      before do
        allow(omnidirectional_movement_pattern_dbl).to receive(:pattern).and_return([[:n, 0], [0, :n],
                                                                                     %i[n n], %i[n nn]])
      end

      subject(:root_position) { described_class.new(coord_dbl, omnidirectional_movement_pattern_dbl) }

      it 'the @child_move_nodes is expected to be a kind of MovePositionNode' do
        root_position.child_move_nodes.each do |child_move_node|
          expect(child_move_node).to be_a(MovePositionNode)
        end
      end

      context 'when there is no requirements restrictions' do
        before do
          allow(MovementUtil).to receive(:comply_with_restrictions).and_return(true)
        end

        it 'is expected to have 8 possible child move nodes' do
          expect(root_position.child_move_nodes.size).to eq(8)
        end

        context 'were the coordinates are expected to be' do
          subject(:root_position_A1) { described_class.new(coord_A1, omnidirectional_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_A1.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_B4) { described_class.new(coord_B4, omnidirectional_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_B4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[0, 2], [0, 3], [0, 4], [1, 2], [1, 4], [2, 2], [2, 3], [2, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_D4) { described_class.new(coord_D4, omnidirectional_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_D4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_E5) { described_class.new(coord_E5, omnidirectional_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_E5.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end
        end
      end
    end

    context 'when testing a knight_L movement pattern' do
      let(:knight_L_movement_pattern_dbl) { movement_pattern_dbl }
      before do
        allow(knight_L_movement_pattern_dbl).to receive(:pattern).and_return([[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                                                                              [-1, +2], [-1, -2], [-2, 1], [-2, -1]])
      end

      subject(:root_position) { described_class.new(coord_dbl, knight_L_movement_pattern_dbl) }

      it 'the @child_move_nodes is expected to be a kind of MovePositionNode' do
        root_position.child_move_nodes.each do |child_move_node|
          expect(child_move_node).to be_a(MovePositionNode)
        end
      end

      context 'when there is no requirements restrictions' do
        before do
          allow(MovementUtil).to receive(:comply_with_restrictions).and_return(true)
        end

        it 'is expected to have 8 possible child move nodes' do
          expect(root_position.child_move_nodes.size).to eq(8)
        end

        context 'were the coordinates are expected to be' do
          subject(:root_position_A1) { described_class.new(coord_A1, knight_L_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_A1.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_B4) { described_class.new(coord_B4, knight_L_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_B4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[-1, 2], [-1, 4], [0, 1], [0, 5], [2, 1], [2, 5], [3, 2], [3, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_D4) { described_class.new(coord_D4, knight_L_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_D4.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[1, 2], [1, 4], [2, 1], [2, 5], [4, 1], [4, 5], [5, 2], [5, 4]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end

          subject(:root_position_E5) { described_class.new(coord_E5, knight_L_movement_pattern_dbl) }
          it '' do
            coordinates = root_position_E5.child_move_nodes.map(&:coordinate).map(&:to_array)
            expected_coordinates = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]

            expect(coordinates.sort).to eq expected_coordinates.sort
          end
        end
      end
    end
  end

  describe '#show_all_possible_moves' do
    subject(:root_position) { described_class.new(coord_dbl, movement_pattern_dbl) }

    context 'when testing a movement like orthogonal movement pattern' do
      before do
        allow(movement_pattern_dbl).to receive(:pattern).and_return([[:n, 0], [0, :n]])
        allow(movement_pattern_dbl).to receive(:requirements).and_return([])

        # This part is challenging to test due to the tree-building algorithm.
        # To simplify future understanding, here's the key concept:
        # For each pattern, the algorithm builds a separate tree using breadth-first traversal.
        # It starts by creating the root of each path and continues expanding the path until reaching nil.
        # Once all open paths for the current pattern are handled, it repeats the process for the next pattern.
        allow(MovementUtil).to receive(:comply_with_restrictions).and_return(
          true, # root of the first pattern tree to the positive direction can be made
          true, # root of the first pattern tree to the negative direction can be made
          true, true, false, # first pattern positive direction path
          true, true, false, # first pattern negative direction path
          true, # root of the second pattern tree to the positive direction can be made
          true, # root of the second pattern tree to the negative direction can be made
          true, true, false, # second pattern positive direction path
          true, true, false  # second pattern positive direction path
        )
      end

      it '' do
        expect(root_position.find_all_paths.map(&:inspect)).to eq ['[(1, 0)c, (2, 0)c, (3, 0)c]',
                                                                   '[(-1, 0)c, (-2, 0)c, (-3, 0)c]', '[(0, 1)c, (0, 2)c, (0, 3)c]', '[(0, -1)c, (0, -2)c, (0, -3)c]']
      end
    end

    context 'when testing movement like diagonal movement pattern' do
      before do
        allow(movement_pattern_dbl).to receive(:pattern).and_return([%i[n n], %i[n nn]])
        allow(movement_pattern_dbl).to receive(:requirements).and_return([])

        # This part is challenging to test due to the tree-building algorithm.
        # To simplify future understanding, here's the key concept:
        # For each pattern, the algorithm builds a separate tree using breadth-first traversal.
        # It starts by creating the root of each path and continues expanding the path until reaching nil.
        # Once all open paths for the current pattern are handled, it repeats the process for the next pattern.
        allow(MovementUtil).to receive(:comply_with_restrictions).and_return(
          true, # root of the first pattern tree to the positive direction can be made
          true, # root of the first pattern tree to the negative direction can be made
          true, true, false, # first pattern positive direction path
          true, true, false, # first pattern negative direction path
          true, # root of the second pattern tree to the positive direction can be made
          true, # root of the second pattern tree to the negative direction can be made
          true, true, false, # second pattern positive direction path
          true, true, false  # second pattern positive direction path
        )
      end

      it '' do
        expect(root_position.find_all_paths.map(&:inspect)).to eq ['[(1, 1)c, (2, 2)c, (3, 3)c]',
                                                                   '[(-1, -1)c, (-2, -2)c, (-3, -3)c]', '[(1, -1)c, (2, -2)c, (3, -3)c]', '[(-1, 1)c, (-2, 2)c, (-3, 3)c]']
      end
    end
  end
end
