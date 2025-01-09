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

  def notation_of_paths(array_of_paths)
    array_of_paths.map { |path| path.map(&:to_notation) }
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
end
