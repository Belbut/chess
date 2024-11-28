# frozen_string_literal: true

require_relative '../lib/chess_kit'
require_relative '../lib/chess_kit/coordinate'

describe ChessKit do
  context 'is composed by' do
    subject(:chess_kit) { described_class.new }
    let(:board) { chess_kit.board }
    context 'A Board' do
      it 'expected to be sized 8x8' do
        height = board.cells.size
        width = board.cells.first.size

        expect(height).to eq 8
        expect(width).to eq 8
      end

      context 'with Pieces' do
        let(:pieces) { board.cells.flatten.reject(&:nil?) }
        let(:white_pieces) { pieces.find_all(&:white?) }
        let(:black_pieces) { pieces.find_all(&:black?) }

        def verify_positions_match_piece(positions, piece_color, piece_type)
          positions.each do |cell_notation|
            cell = Coordinate.from_notation(cell_notation)
            expect(board.lookup_cell(cell).color).to be piece_color
            expect(board.lookup_cell(cell).type).to be piece_type
          end
        end

        it 'starting with a total of 32 pieces' do
          expect(pieces.size).to eq 32
        end
        context 'where' do
          context 'white pieces' do
            let(:context_color) { :white }

            it 'are expected to have 16 on the board' do
              expect(white_pieces.size).to eq 16
            end

            context 'where' do
              let(:find_white_piece) { ->(type) { white_pieces.find_all { |piece| piece.type == type } } }
              context 'pawns' do
                let(:context_piece_type) { :pawn }

                it 'are expected to have 8 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 8
                end

                it 'are expected to stand on the second row' do
                  positions = %w[A2 B2 C2 D2 E2 F2 G2 H2]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'rooks' do
                let(:context_piece_type) { :rook }

                it 'are expected to have 2 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on A1 and H1 cells' do
                  positions = %w[A1 H1]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'knights' do
                let(:context_piece_type) { :knight }

                it 'are expected to have 2 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on B1 and G1 cells' do
                  positions = %w[B1 G1]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'bishops' do
                let(:context_piece_type) { :bishop }

                it 'are expected to have 2 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on C1 and F1 cells' do
                  positions = %w[C1 F1]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'queen' do
                let(:context_piece_type) { :queen }

                it 'is expected to have 1 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 1
                end

                it 'is expected to stand on D1 cell' do
                  positions = %w[D1]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'king' do
                let(:context_piece_type) { :king }

                it 'is expected to have 1 on the board' do
                  context_piece = find_white_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 1
                end

                it 'are expected to stand on E1 cell' do
                  positions = %w[E1]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end
            end
          end
          context 'black pieces' do
            let(:context_color) { :black }

            it 'are expected to have 16 on the board' do
              expect(black_pieces.size).to eq 16
            end

            context 'where' do
              let(:find_black_piece) { ->(type) { black_pieces.find_all { |piece| piece.type == type } } }
              context 'pawns' do
                let(:context_piece_type) { :pawn }

                it 'are expected to have 8 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 8
                end

                it 'are expected to stand on the second row' do
                  positions = %w[A7 B7 C7 D7 E7 F7 G7 H7]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'rooks' do
                let(:context_piece_type) { :rook }

                it 'are expected to have 2 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on A8 and H8 cells' do
                  positions = %w[A8 H8]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'knights' do
                let(:context_piece_type) { :knight }

                it 'are expected to have 2 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on B8 and G8 cells' do
                  positions = %w[B8 G8]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'bishops' do
                let(:context_piece_type) { :bishop }

                it 'are expected to have 2 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 2
                end

                it 'are expected to stand on C8 and F8 cells' do
                  positions = %w[C8 F8]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'queen' do
                let(:context_piece_type) { :queen }

                it 'is expected to have 1 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 1
                end

                it 'is expected to stand on D8 cell' do
                  positions = %w[D8]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end

              context 'king' do
                let(:context_piece_type) { :king }

                it 'is expected to have 1 on the board' do
                  context_piece = find_black_piece.call(context_piece_type)
                  expect(context_piece.size).to eq 1
                end

                it 'are expected to stand on E8 cell' do
                  positions = %w[E8]
                  verify_positions_match_piece(positions, context_color, context_piece_type)
                end
              end
            end
          end
        end
      end
    end
  end
end
