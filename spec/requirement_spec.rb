# frozen_string_literal: true

require_relative '../lib/rules/movement_pattern/requirement'
require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces/unit'
require_relative '../lib/chess_kit/coordinate'

require_relative '../lib/rules/movement_pattern/tree_framework/root_position'
require_relative '../lib/rules/movement_pattern/tree_framework/move_position_node'

require_relative './testing_util_spec'
describe Requirement do
  include TestingUtil

  let(:empty_board) { Board.new(8, 8) }
  let(:random_coord) { instance_double(Coordinate) }

  describe '::target_is_inside_board' do
    let(:target_is_inside_board_requirement) { Requirement.target_is_inside_board(empty_board) }

    let(:valid_target_cord1) { instance_double(Coordinate, x: 1, y: 0) }
    let(:valid_target_cord2) { instance_double(Coordinate, x: 0, y: 1) }
    let(:valid_target_cord3) { instance_double(Coordinate, x: 1, y: 1) }
    let(:valid_target_cord4) { instance_double(Coordinate, x: 7, y: 7) }

    let(:invalid_target_cord1) { instance_double(Coordinate, x: -1, y: 0) }
    let(:invalid_target_cord2) { instance_double(Coordinate, x: 0, y: -1) }
    let(:invalid_target_cord3) { instance_double(Coordinate, x: -1, y: -1) }

    let(:invalid_target_cord4) { instance_double(Coordinate, x: 8, y: 0) }
    let(:invalid_target_cord5) { instance_double(Coordinate, x: 0, y: 8) }

    it 'returns true when the target is inside board' do
      expect(target_is_inside_board_requirement.call(random_coord, valid_target_cord1)).to eq(true)
      expect(target_is_inside_board_requirement.call(random_coord, valid_target_cord2)).to eq(true)
      expect(target_is_inside_board_requirement.call(random_coord, valid_target_cord3)).to eq(true)
      expect(target_is_inside_board_requirement.call(random_coord, valid_target_cord4)).to eq(true)
    end

    it 'returns false when the target is inside board' do
      expect(target_is_inside_board_requirement.call(random_coord, invalid_target_cord1)).to eq(false)
      expect(target_is_inside_board_requirement.call(random_coord, invalid_target_cord2)).to eq(false)
      expect(target_is_inside_board_requirement.call(random_coord, invalid_target_cord3)).to eq(false)
      expect(target_is_inside_board_requirement.call(random_coord, invalid_target_cord4)).to eq(false)
      expect(target_is_inside_board_requirement.call(random_coord, invalid_target_cord5)).to eq(false)
    end
  end

  describe '::parent_move_was_not_a_kill' do
    let(:parent_move_was_not_a_kill_requirement) { Requirement.parent_move_was_not_a_kill(board_with_pieces, :white) }
    let(:board_with_pieces) { empty_board }

    let(:testing_position) { instance_double(Coordinate, x: 3, y: 3) }
    let(:target_cord) { instance_double(Coordinate, x: 3, y: 4) }

    let(:white_piece) { instance_double(Unit, color: :white) }
    let(:black_piece) { instance_double(Unit, color: :black) }

    context 'when there is no piece at the parent coordinate' do
      it 'returns true' do
        expect(parent_move_was_not_a_kill_requirement.call(testing_position, target_cord)).to eq(true)
      end
    end

    context 'when there is a piece of the same team at the parent coordinate' do
      before do
        board_with_pieces.add_to_cell(testing_position, white_piece)
      end

      it 'returns true' do
        expect(parent_move_was_not_a_kill_requirement.call(testing_position, target_cord)).to eq(true)
      end
    end

    context 'when there is a piece of the opposite team at the parent coordinate' do
      before do
        board_with_pieces.add_to_cell(testing_position, black_piece)
      end

      it 'returns false' do
        expect(parent_move_was_not_a_kill_requirement.call(testing_position, target_cord)).to eq(false)
      end
    end
  end

  describe '::target_is_no_friendly_kill' do
    let(:target_is_no_friendly_kill_requirement) { Requirement.target_is_no_friendly_kill(board_with_pieces, :white) }
    let(:board_with_pieces) { empty_board }

    let(:random_coord) { instance_double(Coordinate) }

    let(:white_piece) { instance_double(Unit, color: :white) }
    let(:black_piece) { instance_double(Unit, color: :black) }

    context 'when the target is a empty cell' do
      it 'is expected to return true' do
        expect(target_is_no_friendly_kill_requirement.call(random_coord, coord_D5)).to eq(true)
      end
    end

    context 'when the target cord are occupied by' do
      context 'the same color pieces' do
        before do
          board_with_pieces.add_to_cell(coord_D5, white_piece)
        end

        it 'is expected to return false' do
          expect(target_is_no_friendly_kill_requirement.call(random_coord, coord_D5)).to eq(false)
        end
      end

      context 'different color pieces' do
        before do
          board_with_pieces.add_to_cell(coord_D5, black_piece)
        end

        it 'is expected to return true' do
          expect(target_is_no_friendly_kill_requirement.call(random_coord, coord_D5)).to eq(true)
        end
      end
    end
  end

  describe '::move_is_safe_for_king' do
    # Tested in rules_spec because it requires a integration test due to rules being one of the arguments
  end

  describe '::piece_not_moved' do
    let(:piece_not_moved_requirement) { Requirement.piece_not_moved(board_with_piece) }
    let(:board_with_piece) { empty_board }

    let(:unmoved_piece) { instance_double(Unit, move_status: :unmoved) }

    context 'when the move_status is:' do
      context ':unmoved' do
        let(:unmoved_piece) { instance_double(Unit, move_status: :unmoved) }

        before do
          board_with_piece.add_to_cell(testing_position, unmoved_piece)
        end

        it 'is expected to return false' do
          expect(piece_not_moved_requirement.call(testing_position)).to eq(true)
        end
      end

      context 'do anything other' do
        let(:moved_piece) { instance_double(Unit, move_status: :Symbol) }

        before do
          board_with_piece.add_to_cell(testing_position, moved_piece)
        end

        it 'is expected to return false' do
          expect(piece_not_moved_requirement.call(testing_position)).to eq(false)
        end
      end
    end
  end

  describe '::no_suicide_move' do
    # Tested in rules_spec because it requires a integration test due to rules being one of the arguments
  end

  describe '::empty_row_between' do
    let(:row_between_requirement) { Requirement.empty_row_between(board_with_pieces) }
    let(:board_with_pieces) { empty_board }
    let(:piece) { instance_double(Unit) }

    let(:initial_coord) { instance_double(Coordinate, x: 0, y: 0) }
    let(:final_coord) { instance_double(Coordinate, x: 3, y: 0) }

    context 'when there is no piece between the to coords' do
      let(:not_related_cell) { instance_double(Coordinate, x: 4, y: 0) }
      before do
        board_with_pieces.add_to_cell(not_related_cell, piece)
      end
      it '' do
        expect(row_between_requirement.call(initial_coord, final_coord)).to eq(true)
      end
    end

    context 'when there is pieces between the to coords' do
      let(:middle_cell) { instance_double(Coordinate, x: 1, y: 0) }

      before do
        board_with_pieces.add_to_cell(middle_cell, piece)
      end
      it '' do
        expect(row_between_requirement.call(initial_coord, final_coord)).to eq(false)
      end
    end
  end

  describe '::cell_not_under_attack' do
    let(:cell_not_under_attack_requirement) { Requirement.cell_not_under_attack(board_with_pieces, :white) }
    let(:board_with_pieces) { empty_board }

    context 'when the cell is not under attack ' do
      xit 'is expected to return true' do
        # p RootPosition.new(testing_position,
        #                    PatternRules.new([[:n, 0], [0, :n]],
        #                                     Requirement.standard_requirements(board_with_pieces, :white)))
        # expect(cell_not_under_attack_requirement.call(testing_position)).to eq true
      end
    end
  end

  describe '::target_move_is_kill' do
    let(:target_move_is_kill_requirement) { Requirement.target_move_is_kill(board_with_pieces, :white) }
    let(:board_with_pieces) { empty_board }

    let(:white_piece) { instance_double(Unit, color: :white) }
    let(:black_piece) { instance_double(Unit, color: :black) }

    context 'when the target is a empty cell' do
      before do
        board_with_pieces.add_to_cell(coord_D4, white_piece)
      end

      it 'is expected to return false' do
        expect(target_move_is_kill_requirement.call(coord_D4, coord_D5)).to eq(false)
      end
    end

    context 'when the parent and target cord are occupied by' do
      context 'the same color pieces' do
        before do
          board_with_pieces.add_to_cell(coord_D4, white_piece)
          board_with_pieces.add_to_cell(coord_D5, white_piece)
        end

        it 'is expected to return false' do
          expect(target_move_is_kill_requirement.call(coord_D4, coord_D5)).to eq(false)
        end
      end

      context 'different color pieces' do
        before do
          board_with_pieces.add_to_cell(coord_D4, white_piece)
          board_with_pieces.add_to_cell(coord_D5, black_piece)
        end

        it 'is expected to return true' do
          expect(target_move_is_kill_requirement.call(coord_D4, coord_D5)).to eq(true)
        end
      end
    end
  end

  describe '::target_move_is_flank_kill' do
    let(:target_move_is_flank_kill_requirement) { Requirement.target_move_is_flank_kill(board_with_pieces, :white) }
    let(:board_with_pieces) { empty_board }

    let(:right_rushed_cord) { instance_double(Coordinate, x: 4, y: 3) }
    let(:right_target_cord) { instance_double(Coordinate, x: 4, y: 4) }

    let(:piece_cord) { instance_double(Coordinate, x: 3, y: 3) }

    let(:left_rushed_cord) { instance_double(Coordinate, x: 2, y: 3) }
    let(:left_target_cord) { instance_double(Coordinate, x: 2, y: 4) }

    let(:white_piece) { instance_double(Unit, color: :white) }

    before do
      board_with_pieces.add_to_cell(piece_cord, white_piece)
    end

    context 'when there is no rushed piece' do
      context 'there is no piece' do
        it '' do
          expect(target_move_is_flank_kill_requirement.call(piece_cord, right_target_cord)).to eq(false)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, left_target_cord)).to eq(false)
        end
      end

      context 'the piece doesn\'t have the rushed status' do
        let(:black_piece_not_rushed) { instance_double(Unit, color: :black, move_status: :not_rushed) }

        it '' do
          board_with_pieces.add_to_cell(right_rushed_cord, black_piece_not_rushed)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, right_target_cord)).to eq(false)
        end

        it '' do
          board_with_pieces.add_to_cell(left_rushed_cord, black_piece_not_rushed)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, left_target_cord)).to eq(false)
        end
      end

      context 'when it\'s the same color' do
        it '' do
          board_with_pieces.add_to_cell(left_rushed_cord, white_piece)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, left_target_cord)).to eq(false)
        end

        it '' do
          board_with_pieces.add_to_cell(right_rushed_cord, white_piece)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, right_target_cord)).to eq(false)
        end
      end

      context 'when there is a rushed enemy piece on the correct position' do
        let(:black_piece_rushed) { instance_double(Unit, color: :black, move_status: :rushed) }

        it do
          board_with_pieces.add_to_cell(right_rushed_cord, black_piece_rushed)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, right_target_cord)).to eq(true)
        end
        it do
          board_with_pieces.add_to_cell(left_rushed_cord, black_piece_rushed)
          expect(target_move_is_flank_kill_requirement.call(piece_cord, left_target_cord)).to eq(true)
        end
      end
    end
  end
end
