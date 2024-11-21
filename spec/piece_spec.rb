# frozen_string_literal: true

require_relative '../lib/chess_kit/chess_piece'
require_relative '../lib/chess_kit/pawn'

describe ChessPiece do
  let(:color_dbl) { double('random color') }

  describe ChessPiece::Pawn do
    subject(:pawn) { described_class.new(color_dbl) }

    MOVED_PAWN_MOVE_PATTERN = [[0, 1]].freeze
    UNMOVED_PAWN_MOVE_PATTERN = [[0, 1], [0, 2]].freeze
    PAWN_CAPTURE_PATTERN = [[-1, 1], [1, 1]].freeze

    describe '#type' do
      it do
        expect(pawn.type).to eq :pawn
      end
    end

    describe '#move_pattern' do
      context "when the pawn hasn't moved before" do
        it 'is expected to have the possibility to rush' do
          expect(pawn.move_pattern.sort).to eq UNMOVED_PAWN_MOVE_PATTERN.sort
        end
      end

      context 'when the pawn has moved before' do
        before do
          pawn.mark_as_moved
        end

        it 'is expected to only move one square' do
          expect(pawn.move_pattern.sort).to eq MOVED_PAWN_MOVE_PATTERN.sort
        end
      end

      describe '#mark_as_rushed' do
        context 'when the pawn was unmoved before' do
          it 'is expected to change status to :rushed' do
            expect { pawn.mark_as_rushed }.to change {
              pawn.move_status
            }.from(:unmoved).to(:rushed)
          end
        end

        context 'when the pawn has already moved before' do
          before do
            pawn.mark_as_moved
          end

          it 'is expected to raise a error' do
            expect { pawn.mark_as_rushed }.to raise_error(Exception)
          end
        end
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(pawn.capture_pattern.sort).to eq PAWN_CAPTURE_PATTERN.sort
      end
    end
  end

  describe ChessPiece::Rook do
    subject(:rook) { described_class.new(color_dbl) }

    ROOK_MOVE_PATTERN = [[-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                         [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                         [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                         [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]].freeze

    describe '#type' do
      it do
        expect(rook.type).to eq :rook
      end
    end

    describe '#move_pattern' do
      it 'is expected to store all the possible rook moves' do
        expect(rook.move_pattern.sort).to eq ROOK_MOVE_PATTERN.sort
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(rook.capture_pattern).to eq rook.move_pattern
      end
    end
  end

  describe ChessPiece::Knight do
    subject(:knight) { described_class.new(color_dbl) }

    KNIGHT_MOVE_PATTERN = [[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                           [-1, +2], [-1, -2], [-2, 1], [-2, -1]].freeze

    describe '#type' do
      it do
        expect(knight.type).to eq :knight
      end
    end

    describe '#move_pattern' do
      it 'is expected to store all the possible knight moves' do
        expect(knight.move_pattern.sort).to eq KNIGHT_MOVE_PATTERN.sort
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(knight.capture_pattern).to eq knight.move_pattern
      end
    end
  end

  describe ChessPiece::Bishop do
    subject(:bishop) { described_class.new(color_dbl) }

    BISHOP_MOVE_PATTERN = [[-7, -7], [7, -7], [-6, -6], [6, -6], [-5, -5], [5, -5],
                           [-4, -4], [4, -4], [-3, -3], [3, -3], [-2, -2], [2, -2], [-1, -1],
                           [1, -1], [1, 1], [-1, 1], [2, 2], [-2, 2], [3, 3], [-3, 3], [4, 4],
                           [-4, 4], [5, 5], [-5, 5], [6, 6], [-6, 6], [7, 7], [-7, 7]].freeze

    describe '#type' do
      it do
        expect(bishop.type).to eq :bishop
      end
    end

    describe '#move_pattern' do
      it 'is expected to store all the possible bishop moves' do
        expect(bishop.move_pattern.sort).to eq BISHOP_MOVE_PATTERN.sort
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(bishop.capture_pattern).to eq bishop.move_pattern
      end
    end
  end

  describe ChessPiece::Queen do
    subject(:queen) { described_class.new(color_dbl) }

    QUEEN_MOVE_PATTERN = [[-7, -7], [7, -7], [-6, -6], [6, -6], [-5, -5], [5, -5], [-4, -4],
                          [4, -4], [-3, -3], [3, -3], [-2, -2], [2, -2], [-1, -1], [1, -1],
                          [1, 1], [-1, 1], [2, 2], [-2, 2], [3, 3], [-3, 3], [4, 4], [-4, 4],
                          [5, 5], [-5, 5], [6, 6], [-6, 6], [7, 7], [-7, 7], [-7, 0], [-6, 0],
                          [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0], [0, 1], [0, 2], [0, 3],
                          [0, 4], [0, 5], [0, 6], [0, 7], [0, -7], [0, -6], [0, -5], [0, -4],
                          [0, -3], [0, -2], [0, -1], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]].freeze

    describe '#type' do
      it do
        expect(queen.type).to eq :queen
      end
    end

    describe '#move_pattern' do
      it 'is expected to store all the possible queen moves' do
        expect(queen.move_pattern.sort).to eq QUEEN_MOVE_PATTERN.sort
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(queen.capture_pattern).to eq queen.move_pattern
      end
    end
  end

  describe ChessPiece::King do
    subject(:king) { described_class.new(color_dbl) }

    KING_MOVE_PATTERN = [[-1, -1], [1, -1], [1, 1], [-1, 1],
                         [-1, 0], [0, 1], [0, -1], [1, 0]].freeze

    describe '#type' do
      it do
        expect(king.type).to eq :king
      end
    end

    describe '#move_pattern' do
      it 'is expected to store all the possible king moves' do
        expect(king.move_pattern.sort).to eq KING_MOVE_PATTERN.sort
      end
    end

    describe '#capture_pattern' do
      it 'is expected to be the same as @move_pattern' do
        expect(king.capture_pattern).to eq king.move_pattern
      end
    end
  end
end
