# frozen_string_literal: true

require_relative '../lib/rules/movement_pattern/move_position_node'
require_relative '../lib/rules/movement_pattern/pattern_rules'
require_relative '../lib/chess_kit/coordinate'

describe MovePositionNode do
  subject(:move_position_node) { described_class.new(coordinate_dbl, pattern_dbl, [requirements_dbl], inertia_dbl) }
  let(:coordinate_dbl) { instance_double(Coordinate, x: 0, y: 0) }
  let(:pattern_dbl) { [1, 1] }
  let(:requirements_dbl) { instance_double(Proc) }
  let(:inertia_dbl) { :symbol }

  describe '#child_move_node' do
    context 'when there is no more nodes on this path' do
      let(:inertia_dbl) { nil }

      it 'is expected to return nil' do
        expect(move_position_node.child_move_node).to eq(nil)
      end
    end

    context 'if this is not the last move node' do
      before do
        # prevent infinite loop
        allow(requirements_dbl).to receive(:call).and_return(true, false)
      end

      it 'is expected to return one MovePositionNode' do
        expect(move_position_node.child_move_node).to be_a(MovePositionNode)
      end

      context 'when created by a orthogonal movement' do
        context 'where the propagation pattern is' do
          context '[:n,0]' do
            let(:pattern_dbl) { [:n, 0] }
            context 'movement inertia is' do
              context ':positive' do
                let(:inertia_dbl) { :positive }
                it 'is expected that the next node coordinate is [1,0]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [1, 0]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
              context ':negative' do
                let(:inertia_dbl) { :negative }
                it 'is expected that the next node coordinate is [-1,0]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [-1, 0]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
            end
          end
          context '[0,:n]' do
            let(:pattern_dbl) { [0, :n] }
            context 'movement inertia is' do
              context ':positive' do
                let(:inertia_dbl) { :positive }
                it 'is expected that the next node coordinate is [0,1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [0, 1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
              context ':negative' do
                let(:inertia_dbl) { :negative }
                it 'is expected that the next node coordinate is [0,-1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [0, -1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
            end
          end
        end
      end

      context 'when created by a diagonal movement' do
        context 'where the propagation pattern is' do
          context '[:n,:n]' do
            let(:pattern_dbl) { %i[n n] }
            context 'movement inertia is' do
              context ':positive' do
                let(:inertia_dbl) { :positive }
                it 'is expected that the next node coordinate is [1,1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [1, 1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
              context ':negative' do
                let(:inertia_dbl) { :negative }
                it 'is expected that the next node coordinate is [-1,-1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [-1, -1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
            end
          end
          context '[:n,:nn]' do
            let(:pattern_dbl) { %i[n nn] }
            context 'movement inertia is' do
              context ':positive' do
                let(:inertia_dbl) { :positive }
                it 'is expected that the next node coordinate is [1,-1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [1, -1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
              context ':negative' do
                let(:inertia_dbl) { :negative }
                it 'is expected that the next node coordinate is [-1,1]' do
                  next_node_coordinate = move_position_node.child_move_node.coordinate
                  expected_coordinate = [-1, 1]

                  expect(next_node_coordinate).to eq Coordinate.from_array(expected_coordinate)
                end

                it 'is expected that the next node pattern is the same as the parent' do
                  parent_pattern = move_position_node.pattern
                  next_node_pattern = move_position_node.child_move_node.pattern

                  expect(next_node_pattern).to eq parent_pattern
                end

                it 'is expected that the next node inertia is the same as the parent' do
                  parent_inertia = move_position_node.propagation_inertia
                  next_node_inertia = move_position_node.child_move_node.propagation_inertia

                  expect(next_node_inertia).to eq parent_inertia
                end
              end
            end
          end
        end
      end
    end
  end
end
