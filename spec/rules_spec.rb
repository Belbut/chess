# frozen_string_literal: true

require_relative '../lib/rules'
require_relative '../lib/chess_kit'
require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative './testing_util_spec'

describe Rules do
  include TestingUtil

  subject(:rules) { described_class.new(chess_kit_dbl) }
  let(:chess_kit_dbl) { instance_double(ChessKit, board: board) }
  let(:board) { Board.new(8, 8) }

  def path(*coords)
    [*coords]
  end

  describe '#position_under_attack_from' do
    subject(:position_under_attack_from) { rules.position_under_attack_from(testing_position, team_color).sort }
    let(:team_color) { :white }
    let(:enemy_color) { :black }

    let(:testing_position) { coord_D4 }
    let(:team_piece) { Pieces::FACTORY[team_color][:king] }
    before do
      board.add_to_cell(testing_position, team_piece)
    end

    let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }
    let(:enemy_rook) { Pieces::FACTORY[:black][:rook] }
    let(:enemy_knight) { Pieces::FACTORY[:black][:knight] }
    let(:enemy_bishop) { Pieces::FACTORY[:black][:bishop] }
    let(:enemy_queen) { Pieces::FACTORY[:black][:queen] }
    let(:enemy_king) { Pieces::FACTORY[:black][:king] }

    context 'when no piece is attacking the position' do
      context 'no piece is in a attacking path' do
        it 'is expected to return empty array' do
          puts board
          expect(position_under_attack_from).to eq([])
        end
      end
      context 'the attacking paths are being blocked' do
        before do
          board.add_to_cell(coord_D1, enemy_rook)
          board.add_to_cell(coord_G1, enemy_bishop)
          board.add_to_cell(coord_A7, enemy_queen)
        end
        context 'blocked by friendly piece' do
          let(:friendly_blocking_piece) { Pieces::FACTORY[team_color][:pawn] }

          before do
            board.add_to_cell(coord_B6, friendly_blocking_piece)
            board.add_to_cell(coord_F2, friendly_blocking_piece)
            board.add_to_cell(coord_D3, friendly_blocking_piece)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([])
          end
        end

        context 'blocked by enemy piece' do
          let(:enemy_blocking_piece) { Pieces::FACTORY[enemy_color][:pawn] }
          before do
            board.add_to_cell(coord_B6, enemy_blocking_piece)
            board.add_to_cell(coord_F2, enemy_blocking_piece)
            board.add_to_cell(coord_D3, enemy_blocking_piece)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([])
          end
        end
      end
    end

    context 'when a piece is attacking the position' do
      context 'enemy pawn' do
        context 'by one' do
          let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }
          before do
            board.add_to_cell(coord_E5, enemy_pawn)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_E5])
          end

          context 'one attack position another one blocked' do
            let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }

            before do
              board.add_to_cell(coord_D5, enemy_pawn)
            end

            it '' do
              puts board
              expect(position_under_attack_from).to eq([coord_E5])
            end
          end
        end

        context 'by two' do
          let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            board.add_to_cell(coord_E5, enemy_pawn)
            board.add_to_cell(coord_C5, enemy_pawn)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_C5, coord_E5].sort)
          end
        end
      end

      context 'enemy rooks' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D1, enemy_rook)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_D1])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_A4, enemy_rook)
            board.add_to_cell(coord_H4, enemy_rook)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_H4, coord_A4].sort)
          end
        end
      end

      context 'enemy knights' do
        context 'by one' do
          before do
            board.add_to_cell(coord_B5, enemy_knight)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_B5])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E2, enemy_knight)
            board.add_to_cell(coord_F3, enemy_knight)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_F3, coord_E2].sort)
          end
        end
      end

      context 'enemy bishops' do
        context 'by one' do
          before do
            board.add_to_cell(coord_G1, enemy_bishop)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_G1])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_A1, enemy_bishop)
            board.add_to_cell(coord_A7, enemy_bishop)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_A1, coord_A7].sort)
          end
        end
      end

      context 'enemy queen' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D3, enemy_queen)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_D3])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E3, enemy_queen)
            board.add_to_cell(coord_D5, enemy_queen)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_D5, coord_E3].sort)
          end
        end
      end

      context 'enemy king' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D3, enemy_king)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_D3])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E3, enemy_king)
            board.add_to_cell(coord_D5, enemy_king)
          end

          it '' do
            puts board
            expect(position_under_attack_from).to eq([coord_D5, coord_E3].sort)
          end
        end
      end
    end
  end

  describe '#position_under_attack_from_path' do
    subject(:position_under_attack_from_path) do
      rules.position_under_attack_from_path(testing_position, team_color)
    end
    let(:team_color) { :white }
    let(:enemy_color) { :black }

    let(:testing_position) { coord_D4 }
    let(:team_piece) { Pieces::FACTORY[team_color][:king] }
    before do
      board.add_to_cell(testing_position, team_piece)
    end

    let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }
    let(:enemy_rook) { Pieces::FACTORY[:black][:rook] }
    let(:enemy_knight) { Pieces::FACTORY[:black][:knight] }
    let(:enemy_bishop) { Pieces::FACTORY[:black][:bishop] }
    let(:enemy_queen) { Pieces::FACTORY[:black][:queen] }
    let(:enemy_king) { Pieces::FACTORY[:black][:king] }

    context 'when no piece is attacking the position' do
      context 'no piece is in a attacking path' do
        it 'is expected to return empty array' do
          puts board
          expect(position_under_attack_from_path).to eq([])
        end
      end
      context 'the attacking paths are being blocked' do
        before do
          board.add_to_cell(coord_D1, enemy_rook)
          board.add_to_cell(coord_G1, enemy_bishop)
          board.add_to_cell(coord_A7, enemy_queen)
        end
        context 'blocked by friendly piece' do
          let(:friendly_blocking_piece) { Pieces::FACTORY[team_color][:pawn] }

          before do
            board.add_to_cell(coord_B6, friendly_blocking_piece)
            board.add_to_cell(coord_F2, friendly_blocking_piece)
            board.add_to_cell(coord_D3, friendly_blocking_piece)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([])
          end
        end

        context 'blocked by enemy piece' do
          let(:enemy_blocking_piece) { Pieces::FACTORY[enemy_color][:pawn] }
          before do
            board.add_to_cell(coord_B6, enemy_blocking_piece)
            board.add_to_cell(coord_F2, enemy_blocking_piece)
            board.add_to_cell(coord_D3, enemy_blocking_piece)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([])
          end
        end
      end
    end

    context 'when a piece is attacking the position' do
      context 'enemy pawn' do
        context 'by one' do
          let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }
          before do
            board.add_to_cell(coord_E5, enemy_pawn)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_E5)])
          end

          context 'one attack position another one blocked' do
            let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }

            before do
              board.add_to_cell(coord_D5, enemy_pawn)
            end

            it '' do
              puts board
              expect(position_under_attack_from_path).to eq([path(coord_E5)])
            end
          end
        end

        context 'by two' do
          let(:enemy_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            board.add_to_cell(coord_E5, enemy_pawn)
            board.add_to_cell(coord_C5, enemy_pawn)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_C5), path(coord_E5)])
          end
        end
      end

      context 'enemy rooks' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D1, enemy_rook)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_D3, coord_D2, coord_D1)])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_A4, enemy_rook)
            board.add_to_cell(coord_H4, enemy_rook)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4),
                                                           path(coord_C4, coord_B4, coord_A4)])
          end
        end
      end

      context 'enemy knights' do
        context 'by one' do
          before do
            board.add_to_cell(coord_B5, enemy_knight)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_B5)])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E2, enemy_knight)
            board.add_to_cell(coord_F3, enemy_knight)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_F3), path(coord_E2)])
          end
        end
      end

      context 'enemy bishops' do
        context 'by one' do
          before do
            board.add_to_cell(coord_G1, enemy_bishop)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_E3, coord_F2, coord_G1)])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_A1, enemy_bishop)
            board.add_to_cell(coord_A7, enemy_bishop)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_C3, coord_B2, coord_A1),
                                                           path(coord_C5, coord_B6, coord_A7)])
          end
        end
      end

      context 'enemy queen' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D3, enemy_queen)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_D3)])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E3, enemy_queen)
            board.add_to_cell(coord_D5, enemy_queen)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_D5), path(coord_E3)])
          end
        end
      end

      context 'enemy king' do
        context 'by one' do
          before do
            board.add_to_cell(coord_D3, enemy_king)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_D3)])
          end
        end

        context 'by two' do
          before do
            board.add_to_cell(coord_E3, enemy_king)
            board.add_to_cell(coord_D5, enemy_king)
          end

          it '' do
            puts board
            expect(position_under_attack_from_path).to eq([path(coord_D5), path(coord_E3)])
          end
        end
      end
    end
  end

  describe '#possible_piece_paths_from' do
    context 'picking a rook' do
      let(:black_rook) { Pieces::FACTORY[:black][:rook] }
      context 'from the middle of a empty board' do
        before do
          board.add_to_cell(coord_D4, black_rook)
        end

        it '' do
          print board
          possible_paths = rules.possible_piece_paths_from(coord_D4)

          expect(possible_paths).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4),
                                        path(coord_C4, coord_B4, coord_A4),
                                        path(coord_D5, coord_D6, coord_D7, coord_D8),
                                        path(coord_D3, coord_D2, coord_D1)])
        end
      end

      context 'when the board has other pieces that limit the rook move' do
        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_rook)
            board.add_to_cell(coord_D7, black_pawn)
            board.add_to_cell(coord_D3, black_pawn)
            board.add_to_cell(coord_F4, black_pawn)
            board.add_to_cell(coord_A4, black_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E4), path(coord_C4, coord_B4),
                                          path(coord_D5, coord_D6)])
          end
        end

        context 'other pieces are from the opposite color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_rook)
            board.add_to_cell(coord_D7, white_pawn)
            board.add_to_cell(coord_D3, white_pawn)
            board.add_to_cell(coord_F4, white_pawn)
            board.add_to_cell(coord_A4, white_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E4, coord_F4), path(coord_C4, coord_B4, coord_A4),
                                          path(coord_D5, coord_D6, coord_D7), path(coord_D3)])
          end
        end
      end
    end

    context 'picking a bishop' do
      let(:black_bishop) { Pieces::FACTORY[:black][:bishop] }
      context 'from the middle of a empty board' do
        before do
          board.add_to_cell(coord_D4, black_bishop)
        end

        it '' do
          print board
          possible_paths = rules.possible_piece_paths_from(coord_D4)

          expect(possible_paths).to eq([path(coord_E5, coord_F6, coord_G7, coord_H8), path(coord_C3, coord_B2, coord_A1),
                                        path(coord_E3, coord_F2, coord_G1), path(coord_C5, coord_B6, coord_A7)])
        end
      end

      context 'when the board has other pieces that limit the bishop move' do
        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_bishop)
            board.add_to_cell(coord_G7, black_pawn)
            board.add_to_cell(coord_C3, black_pawn)
            board.add_to_cell(coord_F2, black_pawn)
            board.add_to_cell(coord_A7, black_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E5, coord_F6), path(coord_E3),
                                          path(coord_C5, coord_B6)])
          end
        end

        context 'other pieces are from opposite came color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_bishop)
            board.add_to_cell(coord_G7, white_pawn)
            board.add_to_cell(coord_C3, white_pawn)
            board.add_to_cell(coord_F2, white_pawn)
            board.add_to_cell(coord_A7, white_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E5, coord_F6, coord_G7), path(coord_C3),
                                          path(coord_E3, coord_F2), path(coord_C5, coord_B6, coord_A7)])
          end
        end
      end
    end

    context 'picking a queen' do
      let(:black_queen) { Pieces::FACTORY[:black][:queen] }
      context 'from the middle of a empty board' do
        before do
          board.add_to_cell(coord_D4, black_queen)
        end

        it '' do
          print board
          possible_paths = rules.possible_piece_paths_from(coord_D4)

          expect(possible_paths).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4), path(coord_C4, coord_B4, coord_A4),
                                        path(coord_D5, coord_D6, coord_D7, coord_D8), path(coord_D3, coord_D2, coord_D1),
                                        path(coord_E5, coord_F6, coord_G7, coord_H8), path(coord_C3, coord_B2, coord_A1),
                                        path(coord_E3, coord_F2, coord_G1), path(coord_C5, coord_B6, coord_A7)])
        end
      end

      context 'when the board has other pieces that limit the queen move' do
        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_queen)

            board.add_to_cell(coord_D7, black_pawn)
            board.add_to_cell(coord_D3, black_pawn)
            board.add_to_cell(coord_F4, black_pawn)
            board.add_to_cell(coord_A4, black_pawn)
            board.add_to_cell(coord_G7, black_pawn)
            board.add_to_cell(coord_C3, black_pawn)
            board.add_to_cell(coord_F2, black_pawn)
            board.add_to_cell(coord_A7, black_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E4), path(coord_C4, coord_B4),
                                          path(coord_D5, coord_D6), path(coord_E5, coord_F6), path(coord_E3), path(coord_C5, coord_B6)])
          end
        end

        context 'other pieces are from opposite came color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            board.add_to_cell(coord_D4, black_queen)

            board.add_to_cell(coord_D7, white_pawn)
            board.add_to_cell(coord_D3, white_pawn)
            board.add_to_cell(coord_F4, white_pawn)
            board.add_to_cell(coord_A4, white_pawn)
            board.add_to_cell(coord_G7, white_pawn)
            board.add_to_cell(coord_C3, white_pawn)
            board.add_to_cell(coord_F2, white_pawn)
            board.add_to_cell(coord_A7, white_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E4, coord_F4), path(coord_C4, coord_B4, coord_A4),
                                          path(coord_D5, coord_D6, coord_D7), path(coord_D3), path(coord_E5, coord_F6, coord_G7), path(coord_C3), path(coord_E3, coord_F2), path(coord_C5, coord_B6, coord_A7)])
          end
        end
      end
    end

    context 'picking a knight' do
      let(:black_knight) { Pieces::FACTORY[:black][:knight] }
      context 'that is boxed in all around' do
        let(:black_rook) { Pieces::FACTORY[:black][:rook] }
        let(:white_rook) { Pieces::FACTORY[:white][:rook] }

        before do
          board.add_to_cell(coord_D4, black_knight)

          board.add_to_cell(coord_C3, black_rook)
          board.add_to_cell(coord_D3, black_rook)
          board.add_to_cell(coord_E3, black_rook)
          board.add_to_cell(coord_C4, black_rook)
          board.add_to_cell(coord_E4, white_rook)
          board.add_to_cell(coord_C5, white_rook)
          board.add_to_cell(coord_D5, white_rook)
          board.add_to_cell(coord_E5, white_rook)
        end

        it '' do
          print board
          possible_paths = rules.possible_piece_paths_from(coord_D4)

          expect(possible_paths).to eq([path(coord_F5), path(coord_F3), path(coord_E6), path(coord_E2), path(coord_C6), path(coord_C2), path(coord_B5),
                                        path(coord_B3)])
        end
      end

      context 'when the board has other pieces that limit the knight move' do
        let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }
        let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

        context 'other pieces are from the same color' do
          before do
            board.add_to_cell(coord_D4, black_knight)

            board.add_to_cell(coord_F5, black_pawn)
            board.add_to_cell(coord_F3, black_pawn)
            board.add_to_cell(coord_E6, black_pawn)
            board.add_to_cell(coord_E2, black_pawn)
            board.add_to_cell(coord_C6, black_pawn)
            board.add_to_cell(coord_C2, black_pawn)
            board.add_to_cell(coord_B5, black_pawn)
            board.add_to_cell(coord_B3, black_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([])
          end
        end

        context 'other pieces are from the opposite color' do
          before do
            board.add_to_cell(coord_D4, black_knight)
            board.add_to_cell(coord_F5, white_pawn)
            board.add_to_cell(coord_F3, white_pawn)
            board.add_to_cell(coord_E6, white_pawn)
            board.add_to_cell(coord_E2, white_pawn)
            board.add_to_cell(coord_C6, white_pawn)
            board.add_to_cell(coord_C2, white_pawn)
            board.add_to_cell(coord_B5, white_pawn)
            board.add_to_cell(coord_B3, white_pawn)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_F5), path(coord_F3), path(coord_E6), path(coord_E2), path(coord_C6), path(coord_C2), path(coord_B5),
                                          path(coord_B3)])
          end
        end
      end
    end

    context 'picking a pawn' do
      let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }
      let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

      context 'in the middle of the board' do
        before do
          board.add_to_cell(coord_D4, white_pawn)
        end

        context 'forward move' do
          context 'unmoved pawn' do
            context 'cells free' do
              it '' do
                print board
                possible_paths = rules.possible_piece_paths_from(coord_D4)

                expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
              end
            end

            context 'blocked by' do
              context 'same color piece' do
                it '' do
                  board.add_to_cell(coord_D6, white_pawn)
                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([path(coord_D5)])
                end

                it '' do
                  board.add_to_cell(coord_D5, white_pawn)

                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([])
                end
              end

              context 'opponent color piece' do
                it '' do
                  board.add_to_cell(coord_D6, black_pawn)
                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([path(coord_D5)])
                end

                it '' do
                  board.add_to_cell(coord_D5, black_pawn)

                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([])
                end
              end
            end
          end

          context 'moved pawn' do
            before do
              allow(white_pawn).to receive(:move_status).and_return(:moved)
            end

            context 'cells free' do
              it '' do
                print board
                possible_paths = rules.possible_piece_paths_from(coord_D4)

                expect(possible_paths).to eq([path(coord_D5)])
              end
            end

            context 'blocked by' do
              context 'same color piece' do
                it '' do
                  board.add_to_cell(coord_D5, white_pawn)

                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([])
                end
              end

              context 'opponent color piece' do
                it '' do
                  board.add_to_cell(coord_D5, black_pawn)

                  print board
                  possible_paths = rules.possible_piece_paths_from(coord_D4)

                  expect(possible_paths).to eq([])
                end
              end
            end
          end
        end

        context 'side take' do
          context 'normal take pattern' do
            context 'same color piece' do
              it '' do
                board.add_to_cell(coord_E5, black_pawn)
                board.add_to_cell(coord_C5, black_pawn)

                print board
                possible_paths = rules.possible_piece_paths_from(coord_D4)

                expect(possible_paths).to eq([path(coord_D5), path(coord_D6), path(coord_C5),
                                              path(coord_E5)])
              end
            end

            context 'opponent color piece' do
              it '' do
                board.add_to_cell(coord_E5, white_pawn)
                board.add_to_cell(coord_C5, white_pawn)

                print board
                possible_paths = rules.possible_piece_paths_from(coord_D4)

                expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
              end
            end
          end

          context 'en passant pattern' do
            before do
              allow(black_pawn).to receive(:move_status).and_return(:rushed)
            end

            it '' do
              board.add_to_cell(coord_E4, black_pawn)
              board.add_to_cell(coord_C4, black_pawn)

              print board
              possible_paths = rules.possible_piece_paths_from(coord_D4)

              expect(possible_paths).to eq([path(coord_D5), path(coord_D6), path(coord_C5),
                                            path(coord_E5)])
            end

            context 'without flank exposed' do
              before do
                allow(black_pawn).to receive(:move_status).and_return(:moved)
              end

              it '' do
                board.add_to_cell(coord_E4, black_pawn)
                board.add_to_cell(coord_C4, black_pawn)

                print board
                possible_paths = rules.possible_piece_paths_from(coord_D4)

                expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
              end
            end
          end
        end
      end
    end

    context 'picking a king' do
      let(:black_king) { Pieces::FACTORY[:black][:king] }
      let(:white_rook) { Pieces::FACTORY[:white][:rook] }

      context 'from the middle of a empty board' do
        context 'with no movement restriction' do
          before do
            board.add_to_cell(coord_D4, black_king)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_E4), path(coord_C4),
                                          path(coord_D5), path(coord_D3),
                                          path(coord_E5), path(coord_C3),
                                          path(coord_E3), path(coord_C5)])
          end
        end
        context 'restricted on E row by a rook' do
          before do
            board.add_to_cell(coord_D4, black_king)
            board.add_to_cell(coord_E1, white_rook)
          end

          it '' do
            print board
            possible_paths = rules.possible_piece_paths_from(coord_D4)

            expect(possible_paths).to eq([path(coord_C4), path(coord_D5), path(coord_D3),
                                          path(coord_C3), path(coord_C5)])
          end
        end
      end
    end
  end
end
