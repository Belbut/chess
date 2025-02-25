# frozen_string_literal: true

require_relative '../lib/chess_kit'
require_relative '../lib/chess_kit/coordinate'

require_relative './testing_util_spec'

describe ChessKit do
  include TestingUtil
  subject(:chess_kit) { described_class.new_game }
  let(:board) { chess_kit.board }
  context 'is composed by' do
    context do
      it ' ' do
        puts chess_kit.board
      end
    end
    context 'A Board' do
      it 'expected to be sized 8x8' do
        height = board.matrix.size
        width = board.matrix.first.size

        expect(height).to eq 8
        expect(width).to eq 8
      end

      context 'with Pieces' do
        let(:pieces) { board.contents.flatten.reject(&:nil?) }

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

  context '#to_fen' do
    context 'when the chess_kit is in initial position' do
      let(:fen_result) { chess_kit.to_fen.split(' ') }
      context 'does it return the board in algebraic notation' do
        let(:board_representation) { fen_result[0] }
        let(:rows_representation) { board_representation.split('/') }
        it 'where the 8 rows are separated by"/"' do
          expect(rows_representation.size).to eq 8
        end

        context 'Starting from the back:' do
          it 'first row is represented correctly' do
            expect(rows_representation[0]).to eq 'rnbqkbnr'
          end

          it 'second row is represented correctly' do
            expect(rows_representation[1]).to eq 'pppppppp'
          end

          it 'empty rows are represented correctly' do
            (2..5).each do |index|
              expect(rows_representation[index]).to eq '8'
            end
          end

          it 'seventh row is represented correctly' do
            expect(rows_representation[6]).to eq 'PPPPPPPP'
          end

          it 'eight row is represented correctly' do
            expect(rows_representation[7]).to eq 'RNBQKBNR'
          end
        end
      end

      context 'does it return the representation of the current player' do
        let(:current_color_representation) { fen_result[1] }

        it '' do
          expect(current_color_representation).to eq 'w'
        end
      end

      context 'does it return the representation of the castle availability' do
        let(:castle_condition_representation) { fen_result[2] }

        it '' do
          expect(castle_condition_representation).to eq 'KQkq'
        end
      end

      context 'does it return the representation of the en passant availability' do
        let(:en_passant_representation) { fen_result[3] }

        it '' do
          expect(en_passant_representation).to eq '-'
        end
      end

      context 'does it return the representation of the half move clock' do
        let(:half_move_representation) { fen_result[4] }

        it '' do
          expect(half_move_representation).to eq '0'
        end
      end

      context 'does it return the representation of the full move count' do
        let(:full_move_representation) { fen_result[5] }

        it '' do
          expect(full_move_representation).to eq '1'
        end
      end

      context 'does it represent the full FEN notation' do
        it '' do
          expected_result = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

          expect(chess_kit.to_fen).to eq expected_result
        end
      end
    end

    context 'when the chess_kit mid game' do
      before do
        chess_kit.make_move(coord_E2, coord_E4)
        chess_kit.make_move(coord_C7, coord_C5)
      end

      let(:fen_result) { chess_kit.to_fen.split(' ') }
      context 'does it return the board in algebraic notation' do
        let(:board_representation) { fen_result[0] }
        let(:rows_representation) { board_representation.split('/') }
        it 'where the 8 rows are separated by"/"' do
          expect(rows_representation.size).to eq 8
        end

        context 'Starting from the back:' do
          it 'first row is represented correctly' do
            expect(rows_representation[0]).to eq 'rnbqkbnr'
          end

          it 'second row is represented correctly' do
            expect(rows_representation[1]).to eq 'pp1ppppp'
          end

          it 'third row is represented correctly' do
            expect(rows_representation[2]).to eq '8'
          end

          it 'fourth row is represented correctly' do
            expect(rows_representation[3]).to eq '2p5'
          end

          it 'fifth row is represented correctly' do
            expect(rows_representation[4]).to eq '4P3'
          end

          it 'sixth row is represented correctly' do
            expect(rows_representation[5]).to eq '8'
          end

          it 'seventh row is represented correctly' do
            expect(rows_representation[6]).to eq 'PPPP1PPP'
          end

          it 'eight row is represented correctly' do
            expect(rows_representation[7]).to eq 'RNBQKBNR'
          end
        end
      end

      context 'does it return the representation of the current player' do
        let(:current_color_representation) { fen_result[1] }

        it '' do
          expect(current_color_representation).to eq 'w'
        end
      end

      context 'does it return the representation of the castle availability' do
        let(:castle_condition_representation) { fen_result[2] }

        it '' do
          expect(castle_condition_representation).to eq 'KQkq'
        end
      end

      context 'does it return the representation of the en passant availability' do
        let(:en_passant_representation) { fen_result[3] }

        it '' do
          expect(en_passant_representation).to eq 'c6'
        end
      end

      context 'does it return the representation of the half move clock' do
        let(:half_move_representation) { fen_result[4] }

        it '' do
          expect(half_move_representation).to eq '0'
        end
      end

      context 'does it return the representation of the full move count' do
        let(:full_move_representation) { fen_result[5] }

        it '' do
          expect(full_move_representation).to eq '2'
        end
      end

      context 'does it represent the full FEN notation' do
        it '' do
          puts chess_kit.board

          expected_result = 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2'

          expect(chess_kit.to_fen).to eq expected_result
        end
      end
    end
  end

  context '#from_fen' do
    context 'when fen represents initial position' do
      let(:fen_position_notation) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      let(:testing_chess_kit) { described_class.from_fen(fen_position_notation) }
      let(:reference_chess_kit) { described_class.new_game }

      it 'does the board gets created correctly' do
        expect(reference_chess_kit.board).to eq testing_chess_kit.board
      end

      it 'does the current player gets created correctly' do
        expect(reference_chess_kit.current_color).to eq testing_chess_kit.current_color
      end

      context 'does the pieces movement involved in castling gets created correctly' do
        context 'when there the white castle codes "kq" are missing' do
          let(:fen_no_white_castle) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ - 0 1' }
          let(:testing_no_white_castle) { described_class.from_fen(fen_no_white_castle) }

          it 'is expected to both rook move status to be set to moved' do
            queen_rook = testing_no_white_castle.board.lookup_cell(coord_A1)
            king_rook = testing_no_white_castle.board.lookup_cell(coord_H1)

            expect(queen_rook).to be_a(Pieces::Rook).and have_attributes(move_status: :moved)
            expect(king_rook).to be_a(Pieces::Rook).and have_attributes(move_status: :moved)
          end
        end

        context 'when there the black castle codes "kq" are missing' do
          let(:fen_no_black_castle) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w kq - 0 1' }
          let(:testing_no_black_castle) { described_class.from_fen(fen_no_black_castle) }

          it 'is expected to both rook move status to be set to moved' do
            queen_rook = testing_no_black_castle.board.lookup_cell(coord_A8)
            king_rook = testing_no_black_castle.board.lookup_cell(coord_H8)

            expect(queen_rook).to be_a(Pieces::Rook).and have_attributes(move_status: :moved)
            expect(king_rook).to be_a(Pieces::Rook).and have_attributes(move_status: :moved)
          end
        end
      end

      it 'does the rushed pawn status gets created correctly' do
        expect(testing_chess_kit.board.find_all_positions_of do |cell|
          cell.is_a?(Pieces::Pawn) && cell.rushed?
        end).to be_empty
      end

      it 'does the half move count gets created correctly' do
        expect(reference_chess_kit.half_move_count).to eq testing_chess_kit.half_move_count
      end

      it 'does the full move count gets created correctly' do
        expect(reference_chess_kit.full_move_count).to eq testing_chess_kit.full_move_count
      end
    end
  end

  context '#make_move' do
    let(:pawn_move) { chess_kit.make_move(coord_A2, coord_A3) }
    let(:pawn_rush_move) { chess_kit.make_move(coord_A2, coord_A4) }
    let(:knight_move) { chess_kit.make_move(coord_B1, coord_C3) }
    let(:king_bad_move) { chess_kit.make_move(coord_E1, coord_F1) }
    context 'does it move the selected piece from x to y' do
      it 'removes the piece on x position' do
        expect { pawn_move }.to(change do
          chess_kit.board.lookup_cell(coord_A2)
        end.from(Pieces::Pawn).to(nil))
      end
      context 'the same piece is inserted on y position' do
        context 'if there was another piece in the y position' do
          it 'same color pieces' do
            expect { king_bad_move }.to raise_error(ArgumentError)
          end
          it 'different color pieces' do
            chess_kit.board.clear_cell(coord_D2)

            expect { chess_kit.make_move(coord_D1, coord_D7) }.to(change do
              chess_kit.board.lookup_cell(coord_D7)
            end.from(Pieces::Pawn).to(Pieces::Queen))
          end
        end

        it 'if the y position was empty' do
          expect { pawn_move }.to(change do
            chess_kit.board.lookup_cell(coord_A3)
          end.from(nil).to(Pieces::Pawn))
        end
      end

      context 'does it update the variables' do
        context 'piece move status' do
          context 'correctly distinguishes pawn moves' do
            it 'when it rushes' do
              pawn = chess_kit.board.lookup_cell(coord_H2)

              expect { chess_kit.make_move(coord_H2, coord_H4) }.to(change do
                pawn.move_status
              end.from(:unmoved).to(:rushed))
            end

            it 'when it makes a normal move' do
              pawn = chess_kit.board.lookup_cell(coord_H2)

              expect { chess_kit.make_move(coord_H2, coord_H3) }.to(change do
                pawn.move_status
              end.from(:unmoved).to(:moved))
            end

            it 'when it takes' do
              puts board

              pawn = chess_kit.board.lookup_cell(coord_D2)
              chess_kit.make_move(coord_D2, coord_D4)
              chess_kit.make_move(coord_E7, coord_E5)

              expect { chess_kit.make_move(coord_D4, coord_E5) }.not_to(change do
                pawn.move_status
              end.from(:moved))
              puts board
            end
          end

          context 'all other moves' do
            it 'pawn normal move' do
              pawn = chess_kit.board.lookup_cell(coord_H2)

              expect { chess_kit.make_move(coord_H2, coord_H3) }.to(change do
                pawn.move_status
              end.from(:unmoved).to(:moved))
            end
            it 'noble pice move' do
              rook = chess_kit.board.lookup_cell(coord_H1)

              expect { chess_kit.make_move(coord_H1, coord_H5) }.to(change do
                rook.move_status
              end.from(:unmoved).to(:moved))
            end
          end

          context 'does it rest rushed pawns between turns' do
            it '' do
              testing_pawn = chess_kit.board.lookup_cell(coord_A2)

              expect { chess_kit.make_move(coord_A2, coord_A4) }.to(change do
                testing_pawn.move_status
              end.from(:unmoved).to(:rushed))
              expect { chess_kit.make_move(coord_A7, coord_A6) }.to(change do
                testing_pawn.move_status
              end.from(:rushed).to(:moved))
            end
          end
        end

        context 'current player' do
          it 'from white to black player' do
            expect { pawn_move }.to(change { chess_kit.current_color }.from(:w).to(:b))
          end
          it 'consecutive from white to black back to white' do
            expect { chess_kit.make_move(coord_A2, coord_A3) }.to(change { chess_kit.current_color }.from(:w).to(:b))
            expect { chess_kit.make_move(coord_A7, coord_A6) }.to(change { chess_kit.current_color }.from(:b).to(:w))
          end
        end

        context ' full count move' do
          it 'it increases the full move count' do
            expect { chess_kit.make_move(coord_A2, coord_A3) }.not_to(change { chess_kit.full_move_count })
            expect { chess_kit.make_move(coord_A7, coord_A6) }.to(change { chess_kit.full_move_count }.from(1).to(2))
            expect { chess_kit.make_move(coord_A3, coord_A4) }.not_to(change { chess_kit.full_move_count })
            expect { chess_kit.make_move(coord_A6, coord_A5) }.to(change { chess_kit.full_move_count }.from(2).to(3))
          end
        end

        context 'half count move' do
          let(:random_int) { 42 }
          before do
            chess_kit.instance_variable_set(:@half_move_count, random_int)
          end

          context 'when the move is made from a noble piece' do
            it 'it should increase the half move count by 1 ' do
              expect { knight_move }.to(change { chess_kit.half_move_count }.by(1))
            end
          end

          context 'if it should reset the count' do
            it 'because it was a pawn move' do
              expect { pawn_move }.to(change { chess_kit.half_move_count }.from(random_int).to(0))
            end

            it ' because it was a capture move' do
              expect { chess_kit.make_move(coord_D1, coord_H8) }.to(change do
                chess_kit.half_move_count
              end.from(random_int).to(0))
            end
          end
        end
      end
    end
  end
end
