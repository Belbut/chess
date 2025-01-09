# frozen_string_literal: true

require_relative '../lib/game'

require_relative '../lib/chess_kit/coordinate'
require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

describe Game do
  subject(:game) { described_class.new }

  def notation_of_paths(array_of_paths)
    array_of_paths.map { |path| path.map(&:to_notation) }
  end

  describe '#paths_of_picked_piece' do
    let(:coord_D4) { Coordinate.from_notation('D4') }
    let(:empty_board) { Board.new(8, 8) }

    context 'picking a rook' do
      let(:black_rook) { Pieces::FACTORY[:black][:rook] }
      context 'from the middle of a empty board' do
        before do
          empty_board.add_to_cell(coord_D4, black_rook)
          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        it '' do
          print game.chess_kit
          possible_paths = game.paths_of_picked_piece(coord_D4)

          expect(notation_of_paths(possible_paths)).to eq([%w[E4 F4 G4 H4], %w[C4 B4 A4],
                                                           %w[D5 D6 D7 D8], %w[D3 D2 D1]])
        end
      end

      context 'when the board has other pieces that limit the rook move' do
        let(:coord_D7) { Coordinate.from_notation('D7') }
        let(:coord_D3) { Coordinate.from_notation('D3') }
        let(:coord_F4) { Coordinate.from_notation('F4') }
        let(:coord_A4) { Coordinate.from_notation('A4') }

        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_rook)
            empty_board.add_to_cell(coord_D7, black_pawn)
            empty_board.add_to_cell(coord_D3, black_pawn)
            empty_board.add_to_cell(coord_F4, black_pawn)
            empty_board.add_to_cell(coord_A4, black_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([%w[E4], %w[C4 B4],
                                                             %w[D5 D6]])
          end
        end

        context 'other pieces are from the opposite color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_rook)
            empty_board.add_to_cell(coord_D7, white_pawn)
            empty_board.add_to_cell(coord_D3, white_pawn)
            empty_board.add_to_cell(coord_F4, white_pawn)
            empty_board.add_to_cell(coord_A4, white_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([%w[E4 F4], %w[C4 B4 A4],
                                                             %w[D5 D6 D7], %w[D3]])
          end
        end
      end
    end

    context 'picking a bishop' do
      let(:black_bishop) { Pieces::FACTORY[:black][:bishop] }
      context 'from the middle of a empty board' do
        before do
          empty_board.add_to_cell(coord_D4, black_bishop)
          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        it '' do
          print game.chess_kit
          possible_paths = game.paths_of_picked_piece(coord_D4)

          expect(notation_of_paths(possible_paths)).to eq([%w[E5 F6 G7 H8], %w[C3 B2 A1],
                                                           %w[E3 F2 G1], %w[C5 B6 A7]])
        end
      end

      context 'when the board has other pieces that limit the bishop move' do
        let(:coord_G7) { Coordinate.from_notation('G7') }
        let(:coord_C3) { Coordinate.from_notation('C3') }
        let(:coord_F2) { Coordinate.from_notation('F2') }
        let(:coord_A7) { Coordinate.from_notation('A7') }

        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_bishop)
            empty_board.add_to_cell(coord_G7, black_pawn)
            empty_board.add_to_cell(coord_C3, black_pawn)
            empty_board.add_to_cell(coord_F2, black_pawn)
            empty_board.add_to_cell(coord_A7, black_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([%w[E5 F6], %w[E3], %w[C5 B6]])
          end
        end

        context 'other pieces are from opposite came color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_bishop)
            empty_board.add_to_cell(coord_G7, white_pawn)
            empty_board.add_to_cell(coord_C3, white_pawn)
            empty_board.add_to_cell(coord_F2, white_pawn)
            empty_board.add_to_cell(coord_A7, white_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([%w[E5 F6 G7], %w[C3],
                                                             %w[E3 F2], %w[C5 B6 A7]])
          end
        end
      end
    end

    context 'picking a queen' do
      let(:black_queen) { Pieces::FACTORY[:black][:queen] }
      context 'from the middle of a empty board' do
        before do
          empty_board.add_to_cell(coord_D4, black_queen)
          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        it '' do
          print game.chess_kit
          possible_paths = game.paths_of_picked_piece(coord_D4)

          expect(notation_of_paths(possible_paths)).to eq([%w[E4 F4 G4 H4], %w[C4 B4 A4],
                                                           %w[D5 D6 D7 D8], %w[D3 D2 D1],
                                                           %w[E5 F6 G7 H8], %w[C3 B2 A1],
                                                           %w[E3 F2 G1], %w[C5 B6 A7]])
        end
      end

      context 'when the board has other pieces that limit the queen move' do
        let(:coord_D7) { Coordinate.from_notation('D7') }
        let(:coord_D3) { Coordinate.from_notation('D3') }
        let(:coord_F4) { Coordinate.from_notation('F4') }
        let(:coord_A4) { Coordinate.from_notation('A4') }
        let(:coord_G7) { Coordinate.from_notation('G7') }
        let(:coord_C3) { Coordinate.from_notation('C3') }
        let(:coord_F2) { Coordinate.from_notation('F2') }
        let(:coord_A7) { Coordinate.from_notation('A7') }

        context 'other pieces are from the same color' do
          let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_queen)

            empty_board.add_to_cell(coord_D7, black_pawn)
            empty_board.add_to_cell(coord_D3, black_pawn)
            empty_board.add_to_cell(coord_F4, black_pawn)
            empty_board.add_to_cell(coord_A4, black_pawn)
            empty_board.add_to_cell(coord_G7, black_pawn)
            empty_board.add_to_cell(coord_C3, black_pawn)
            empty_board.add_to_cell(coord_F2, black_pawn)
            empty_board.add_to_cell(coord_A7, black_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([['E4'], %w[C4 B4],
                                                             %w[D5 D6], %w[E5 F6], ['E3'], %w[C5 B6]])
          end
        end

        context 'other pieces are from opposite came color' do
          let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

          before do
            empty_board.add_to_cell(coord_D4, black_queen)

            empty_board.add_to_cell(coord_D7, white_pawn)
            empty_board.add_to_cell(coord_D3, white_pawn)
            empty_board.add_to_cell(coord_F4, white_pawn)
            empty_board.add_to_cell(coord_A4, white_pawn)
            empty_board.add_to_cell(coord_G7, white_pawn)
            empty_board.add_to_cell(coord_C3, white_pawn)
            empty_board.add_to_cell(coord_F2, white_pawn)
            empty_board.add_to_cell(coord_A7, white_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([%w[E4 F4], %w[C4 B4 A4],
                                                             %w[D5 D6 D7], ['D3'], %w[E5 F6 G7], ['C3'], %w[E3 F2], %w[C5 B6 A7]])
          end
        end
      end
    end

    context 'picking a knight' do
      let(:black_knight) { Pieces::FACTORY[:black][:knight] }
      context 'that is boxed in all around' do
        let(:coord_C3) { Coordinate.from_notation('C3') }
        let(:coord_D3) { Coordinate.from_notation('D3') }
        let(:coord_E3) { Coordinate.from_notation('E3') }
        let(:coord_C4) { Coordinate.from_notation('C4') }
        let(:coord_E4) { Coordinate.from_notation('E4') }
        let(:coord_C5) { Coordinate.from_notation('C5') }
        let(:coord_D5) { Coordinate.from_notation('D5') }
        let(:coord_E5) { Coordinate.from_notation('E5') }

        let(:black_rook) { Pieces::FACTORY[:black][:rook] }
        let(:white_rook) { Pieces::FACTORY[:white][:rook] }

        before do
          empty_board.add_to_cell(coord_D4, black_knight)

          empty_board.add_to_cell(coord_C3, black_rook)
          empty_board.add_to_cell(coord_D3, black_rook)
          empty_board.add_to_cell(coord_E3, black_rook)
          empty_board.add_to_cell(coord_C4, black_rook)
          empty_board.add_to_cell(coord_E4, white_rook)
          empty_board.add_to_cell(coord_C5, white_rook)
          empty_board.add_to_cell(coord_D5, white_rook)
          empty_board.add_to_cell(coord_E5, white_rook)

          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        it '' do
          print game.chess_kit
          possible_paths = game.paths_of_picked_piece(coord_D4)

          expect(notation_of_paths(possible_paths)).to eq([['F5'], ['F3'], ['E6'], ['E2'], ['C6'], ['C2'], ['B5'],
                                                           ['B3']])
        end
      end

      context 'when the board has other pieces that limit the knight move' do
        let(:coord_F5) { Coordinate.from_notation('F5') }
        let(:coord_F3) { Coordinate.from_notation('F3') }
        let(:coord_E6) { Coordinate.from_notation('E6') }
        let(:coord_E2) { Coordinate.from_notation('E2') }
        let(:coord_C6) { Coordinate.from_notation('C6') }
        let(:coord_C2) { Coordinate.from_notation('C2') }
        let(:coord_B5) { Coordinate.from_notation('B5') }
        let(:coord_B3) { Coordinate.from_notation('B3') }

        let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }
        let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }

        context 'other pieces are from the same color' do
          before do
            empty_board.add_to_cell(coord_D4, black_knight)

            empty_board.add_to_cell(coord_F5, black_pawn)
            empty_board.add_to_cell(coord_F3, black_pawn)
            empty_board.add_to_cell(coord_E6, black_pawn)
            empty_board.add_to_cell(coord_E2, black_pawn)
            empty_board.add_to_cell(coord_C6, black_pawn)
            empty_board.add_to_cell(coord_C2, black_pawn)
            empty_board.add_to_cell(coord_B5, black_pawn)
            empty_board.add_to_cell(coord_B3, black_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([])
          end
        end

        context 'other pieces are from the opposite color' do
          before do
            empty_board.add_to_cell(coord_D4, black_knight)
            empty_board.add_to_cell(coord_F5, white_pawn)
            empty_board.add_to_cell(coord_F3, white_pawn)
            empty_board.add_to_cell(coord_E6, white_pawn)
            empty_board.add_to_cell(coord_E2, white_pawn)
            empty_board.add_to_cell(coord_C6, white_pawn)
            empty_board.add_to_cell(coord_C2, white_pawn)
            empty_board.add_to_cell(coord_B5, white_pawn)
            empty_board.add_to_cell(coord_B3, white_pawn)
            game.chess_kit.instance_variable_set(:@board, empty_board)
          end

          it '' do
            print game.chess_kit
            possible_paths = game.paths_of_picked_piece(coord_D4)

            expect(notation_of_paths(possible_paths)).to eq([['F5'], ['F3'], ['E6'], ['E2'], ['C6'], ['C2'], ['B5'],
                                                             ['B3']])
          end
        end
      end
    end

    context 'picking a pawn' do
      let(:white_pawn) { Pieces::FACTORY[:white][:pawn] }
      let(:black_pawn) { Pieces::FACTORY[:black][:pawn] }

      context 'in the middle of the board' do
        before do
          empty_board.add_to_cell(coord_D4, white_pawn)
          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        context 'forward move' do
          let(:coord_D5) { Coordinate.from_notation('D5') }
          let(:coord_D6) { Coordinate.from_notation('D6') }

          context 'unmoved pawn' do
            context 'cells free' do
              it '' do
                print game.chess_kit
                possible_paths = game.paths_of_picked_piece(coord_D4)

                expect(notation_of_paths(possible_paths)).to eq([%w[D5], %w[D6]])
              end
            end

            context 'blocked by' do
              context 'same color piece' do
                it '' do
                  empty_board.add_to_cell(coord_D6, white_pawn)
                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([%w[D5]])
                end

                it '' do
                  empty_board.add_to_cell(coord_D5, white_pawn)

                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([])
                end
              end

              context 'opponent color piece' do
                it '' do
                  empty_board.add_to_cell(coord_D6, black_pawn)
                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([%w[D5]])
                end

                it '' do
                  empty_board.add_to_cell(coord_D5, black_pawn)

                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([])
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
                print game.chess_kit
                possible_paths = game.paths_of_picked_piece(coord_D4)

                expect(notation_of_paths(possible_paths)).to eq([%w[D5]])
              end
            end

            context 'blocked by' do
              context 'same color piece' do
                it '' do
                  empty_board.add_to_cell(coord_D5, white_pawn)

                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([])
                end
              end

              context 'opponent color piece' do
                it '' do
                  empty_board.add_to_cell(coord_D5, black_pawn)

                  print game.chess_kit
                  possible_paths = game.paths_of_picked_piece(coord_D4)

                  expect(notation_of_paths(possible_paths)).to eq([])
                end
              end
            end
          end
        end

        context 'side take' do
          let(:coord_C5) { Coordinate.from_notation('C5') }
          let(:coord_E5) { Coordinate.from_notation('E5') }

          context 'normal take pattern' do
            context 'same color piece' do
              it '' do
                empty_board.add_to_cell(coord_E5, black_pawn)
                empty_board.add_to_cell(coord_C5, black_pawn)

                print game.chess_kit
                possible_paths = game.paths_of_picked_piece(coord_D4)

                expect(notation_of_paths(possible_paths)).to eq([['D5'], ['D6'], ['C5'], ['E5']])
              end
            end

            context 'opponent color piece' do
              it '' do
                empty_board.add_to_cell(coord_E5, white_pawn)
                empty_board.add_to_cell(coord_C5, white_pawn)

                print game.chess_kit
                possible_paths = game.paths_of_picked_piece(coord_D4)

                expect(notation_of_paths(possible_paths)).to eq([['D5'], ['D6']])
              end
            end
          end

          context 'en passant pattern' do
            let(:coord_C4) { Coordinate.from_notation('C4') }
            let(:coord_E4) { Coordinate.from_notation('E4') }
            before do
              allow(black_pawn).to receive(:move_status).and_return(:rushed)
            end

            it '' do
              empty_board.add_to_cell(coord_E4, black_pawn)
              empty_board.add_to_cell(coord_C4, black_pawn)

              print game.chess_kit
              possible_paths = game.paths_of_picked_piece(coord_D4)

              expect(notation_of_paths(possible_paths)).to eq([['D5'], ['D6'], ['C5'], ['E5']])
            end

            context 'without flank exposed' do
              before do
                allow(black_pawn).to receive(:move_status).and_return(:moved)
              end

              it '' do
                empty_board.add_to_cell(coord_E4, black_pawn)
                empty_board.add_to_cell(coord_C4, black_pawn)

                print game.chess_kit
                possible_paths = game.paths_of_picked_piece(coord_D4)

                expect(notation_of_paths(possible_paths)).to eq([['D5'], ['D6']])
              end
            end
          end
        end
      end
    end

    context 'picking a king' do
      let(:black_king) { Pieces::FACTORY[:black][:king] }

      context 'from the middle of a empty board' do
        before do
          empty_board.add_to_cell(coord_D4, black_king)
          game.chess_kit.instance_variable_set(:@board, empty_board)
        end

        it '' do
          print game.chess_kit
          possible_paths = game.paths_of_picked_piece(coord_D4)

          expect(notation_of_paths(possible_paths)).to eq([%w[E4], %w[C4],
                                                           %w[D5], %w[D3],
                                                           %w[E5], %w[C3],
                                                           %w[E3], %w[C5]])
        end
      end
    end
  end
end
