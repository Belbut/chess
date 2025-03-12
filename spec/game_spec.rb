# frozen_string_literal: true

require_relative '../lib/game'
require_relative './testing_util_spec'

EXPECTED_FEN_WHITE_PAWN_FIRST_MOVE = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
EXPECTED_FEN_WHITE_KNIGHT_FIRST_MOVE = 'rnbqkbnr/pppppppp/8/8/8/2N5/PPPPPPPP/R1BQKBNR b KQkq - 1 1'

EXPECTED_FEN_WHITE_PAWN_NORMAL_TAKE = 'rnbqkbnr/ppp1pppp/8/3P4/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 2'
EXPECTED_FEN_BLACK_PAWN_NORMAL_TAKE = 'rnbqkbnr/ppp1pppp/8/8/4p3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 0 3'
EXPECTED_FEN_WHITE_KNIGHT_NORMAL_TAKE = 'rnbqkbnr/ppp1pppp/8/8/4N3/8/PPPP1PPP/R1BQKBNR b KQkq - 0 3'

EXPECTED_FEN_WHITE_PAWN_EN_PASSANT_TAKE = 'rnbqkbnr/ppp1p1pp/5P2/3p4/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 3'

EXPECTED_FEN_WHITE_QUEEN_SIDE_CASTLE = '-'
EXPECTED_FEN_WHITE_KING_SIDE_CASTLE = '-'

describe Game do
  include TestingUtil

  def setup_game(arg)
    round_moves = []
    game_should_end_stack = []

    arg.each do |plp|
      round_moves.append(plp)
      game_should_end_stack.append(false)
    end

    game_should_end_stack.pop
    game_should_end_stack.append(true)

    allow(Interface).to receive(:get_round_moves).and_return(*round_moves)
    allow(game).to receive(:game_should_end).and_return(*game_should_end_stack)
  end

  subject(:game) { described_class.new }
  let(:moves_stack) { [] }

  before do
    allow(Interface).to receive(:game_greeting)
    allow(Interface).to receive(:display_chess_board)
  end

  context 'from new game state' do
    describe '#play' do
      context 'do pieces move' do
        context 'first moves' do
          context 'pawn' do
            it 'e2 to e4' do
              moves_stack.append([coord_E2, coord_E4])
              setup_game(moves_stack)

              game.play
              expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_WHITE_PAWN_FIRST_MOVE
            end
          end
          context 'knight' do
            it 'b1 to c3' do
              moves_stack.append([coord_B1, coord_C3])
              setup_game(moves_stack)

              game.play
              expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_WHITE_KNIGHT_FIRST_MOVE
            end
          end
        end
        context 'castle move pattern' do
          context 'king side' do
            context 'white player' do
              before do
                moves_stack.append([coord_G1, coord_F3])
                moves_stack.append([coord_D7, coord_D5])
                moves_stack.append([coord_G2, coord_G3])
                moves_stack.append([coord_G8, coord_F6])
                moves_stack.append([coord_F1, coord_G2])
                moves_stack.append([coord_C7, coord_C6])
              end

              it 'O-O f1 to g1' do
                moves_stack.append([coord_E1, coord_G1])
                setup_game(moves_stack)

                game.play
                expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_WHITE_QUEEN_SIDE_CASTLE
              end
            end
          end

          context 'queen side' do
          end
        end
      end
      context 'is the take movement working' do
        context 'white piece take' do
          before do
            moves_stack.append([coord_E2, coord_E4])
            moves_stack.append([coord_D7, coord_D5])
          end

          it 'e4 to d5' do
            moves_stack.append([coord_E4, coord_D5])
            setup_game(moves_stack)

            game.play
            expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_WHITE_PAWN_NORMAL_TAKE
          end
        end
        context 'black piece take' do
          before do
            moves_stack.append([coord_E2, coord_E4])
            moves_stack.append([coord_D7, coord_D5])
            moves_stack.append([coord_B1, coord_C3])
          end

          it 'd5 to e4' do
            moves_stack.append([coord_D5, coord_E4])
            setup_game(moves_stack)

            game.play
            expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_BLACK_PAWN_NORMAL_TAKE
          end
        end
        context 'white en passant' do
          before do
            moves_stack.append([coord_E2, coord_E4])
            moves_stack.append([coord_D7, coord_D5])
            moves_stack.append([coord_E4, coord_E5])
            moves_stack.append([coord_F7, coord_F5])
          end

          it 'd5 to e4' do
            moves_stack.append([coord_E5, coord_F6])
            setup_game(moves_stack)

            game.play
            expect(game.chess_kit.to_fen).to eq EXPECTED_FEN_WHITE_PAWN_EN_PASSANT_TAKE
          end
        end
      end
    end
  end
end
