# frozen_string_literal: true

require_relative '../lib/rules'
require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative './testing_util_spec'

describe Rules do
  describe Movement do
    include TestingUtil

    subject(:rules) { Rules.new(chess_kit) }
    let(:chess_kit) { ChessKit.new_match }
    let(:board) { chess_kit.board }

    before do
      allow(chess_kit).to receive(:board).and_return(Board.new(8, 8))
    end

    def board_visualization
      should_print = false

      should_print && puts(board)
    end

    describe '#attackers_coordinates_to_position' do
      subject(:attackers_coordinates_to_position) do
        rules.attackers_coordinates_to_position(testing_position, team_color).sort
      end

      before do
        board.add_to_cell_content(testing_position, team_piece)
      end

      context 'when no piece is attacking the position' do
        context 'no piece is in a attacking path' do
          it 'is expected to return empty array' do
            board_visualization

            expect(attackers_coordinates_to_position).to eq([])
          end
        end
        context 'the attacking paths are being blocked' do
          before do
            board.add_to_cell_content(coord_D1, enemy_rook)
            board.add_to_cell_content(coord_G1, enemy_bishop)
            board.add_to_cell_content(coord_A7, enemy_queen)
          end
          context 'blocked by friendly piece' do
            let(:friendly_blocking_piece) { Pieces::FACTORY[team_color][:pawn] }

            before do
              board.add_to_cell_content(coord_B6, friendly_blocking_piece)
              board.add_to_cell_content(coord_F2, friendly_blocking_piece)
              board.add_to_cell_content(coord_D3, friendly_blocking_piece)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([])
            end
          end

          context 'blocked by enemy piece' do
            before do
              board.add_to_cell_content(coord_B6, enemy_blocking_piece)
              board.add_to_cell_content(coord_F2, enemy_blocking_piece)
              board.add_to_cell_content(coord_D3, enemy_blocking_piece)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([])
            end
          end
        end
      end

      context 'when a piece is attacking the position' do
        context 'enemy pawn' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_E5, enemy_pawn)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_E5])
            end

            context 'one attack position another one blocked' do
              before do
                board.add_to_cell_content(coord_D5, enemy_pawn)
              end

              it '' do
                board_visualization

                expect(attackers_coordinates_to_position).to eq([coord_E5])
              end
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E5, enemy_pawn)
              board.add_to_cell_content(coord_C5, enemy_pawn)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_C5, coord_E5].sort)
            end
          end
        end

        context 'enemy rooks' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D1, enemy_rook)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_D1])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_A4, enemy_rook)
              board.add_to_cell_content(coord_H4, enemy_rook)
            end

            it '' do
              board_visualization
              puts board

              expect(attackers_coordinates_to_position).to eq([coord_H4, coord_A4].sort)
            end
          end
        end

        context 'enemy knights' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_B5, enemy_knight)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_B5])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E2, enemy_knight)
              board.add_to_cell_content(coord_F3, enemy_knight)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_F3, coord_E2].sort)
            end
          end
        end

        context 'enemy bishops' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_G1, enemy_bishop)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_G1])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_A1, enemy_bishop)
              board.add_to_cell_content(coord_A7, enemy_bishop)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_A1, coord_A7].sort)
            end
          end
        end

        context 'enemy queen' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D3, enemy_queen)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_D3])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E3, enemy_queen)
              board.add_to_cell_content(coord_D5, enemy_queen)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_D5, coord_E3].sort)
            end
          end
        end

        context 'enemy king' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D3, enemy_king)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_D3])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E3, enemy_king)
              board.add_to_cell_content(coord_D5, enemy_king)
            end

            it '' do
              board_visualization

              expect(attackers_coordinates_to_position).to eq([coord_D5, coord_E3].sort)
            end
          end
        end
      end
    end

    describe '#attack_paths_to_position' do
      subject(:attack_paths_to_position) do
        rules.attack_paths_to_position(testing_position, team_color)
      end

      before do
        board.add_to_cell_content(testing_position, team_piece)
      end

      context 'when no piece is attacking the position' do
        context 'no piece is in a attacking path' do
          it 'is expected to return empty array' do
            board_visualization

            expect(attack_paths_to_position).to eq([])
          end
        end
        context 'the attacking paths are being blocked' do
          before do
            board.add_to_cell_content(coord_D1, enemy_rook)
            board.add_to_cell_content(coord_G1, enemy_bishop)
            board.add_to_cell_content(coord_A7, enemy_queen)
          end
          context 'blocked by friendly piece' do
            before do
              board.add_to_cell_content(coord_B6, friendly_blocking_piece)
              board.add_to_cell_content(coord_F2, friendly_blocking_piece)
              board.add_to_cell_content(coord_D3, friendly_blocking_piece)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([])
            end
          end

          context 'blocked by enemy piece' do
            before do
              board.add_to_cell_content(coord_B6, enemy_blocking_piece)
              board.add_to_cell_content(coord_F2, enemy_blocking_piece)
              board.add_to_cell_content(coord_D3, enemy_blocking_piece)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([])
            end
          end
        end
      end

      context 'when a piece is attacking the position' do
        context 'enemy pawn' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_E5, enemy_pawn)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_E5)])
            end

            context 'one attack position another one blocked' do
              before do
                board.add_to_cell_content(coord_D5, enemy_pawn)
              end

              it '' do
                board_visualization

                expect(attack_paths_to_position).to eq([path(coord_E5)])
              end
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E5, enemy_pawn)
              board.add_to_cell_content(coord_C5, enemy_pawn)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_C5), path(coord_E5)])
            end
          end
        end

        context 'enemy rooks' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D1, enemy_rook)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_D3, coord_D2, coord_D1)])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_A4, enemy_rook)
              board.add_to_cell_content(coord_H4, enemy_rook)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4),
                                                      path(coord_C4, coord_B4, coord_A4)])
            end
          end
        end

        context 'enemy knights' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_B5, enemy_knight)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_B5)])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E2, enemy_knight)
              board.add_to_cell_content(coord_F3, enemy_knight)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_F3), path(coord_E2)])
            end
          end
        end

        context 'enemy bishops' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_G1, enemy_bishop)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_E3, coord_F2, coord_G1)])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_A1, enemy_bishop)
              board.add_to_cell_content(coord_A7, enemy_bishop)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_C3, coord_B2, coord_A1),
                                                      path(coord_C5, coord_B6, coord_A7)])
            end
          end
        end

        context 'enemy queen' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D3, enemy_queen)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_D3)])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E3, enemy_queen)
              board.add_to_cell_content(coord_D5, enemy_queen)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_D5), path(coord_E3)])
            end
          end
        end

        context 'enemy king' do
          context 'by one' do
            before do
              board.add_to_cell_content(coord_D3, enemy_king)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_D3)])
            end
          end

          context 'by two' do
            before do
              board.add_to_cell_content(coord_E3, enemy_king)
              board.add_to_cell_content(coord_D5, enemy_king)
            end

            it '' do
              board_visualization

              expect(attack_paths_to_position).to eq([path(coord_D5), path(coord_E3)])
            end
          end
        end
      end
    end

    describe '#available_paths_for_piece' do
      before do
        allow(Requirement).to receive(:move_is_safe_for_king).and_return(proc { true })
      end

      context 'picking a pawn' do
        context 'in the middle of the board' do
          before do
            board.add_to_cell_content(testing_position, team_pawn)
          end

          context 'forward move' do
            context 'unmoved pawn' do
              context 'cells free' do
                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
                end
              end

              context 'blocked by' do
                context 'same color piece' do
                  it '' do
                    board.add_to_cell_content(coord_D6, enemy_pawn)
                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

                    expect(possible_paths).to eq([path(coord_D5)])
                  end

                  it '' do
                    board.add_to_cell_content(coord_D5, enemy_pawn)

                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

                    expect(possible_paths).to eq([])
                  end
                end

                context 'opponent color piece' do
                  it '' do
                    board.add_to_cell_content(coord_D6, team_pawn)
                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

                    expect(possible_paths).to eq([path(coord_D5)])
                  end

                  it '' do
                    board.add_to_cell_content(coord_D5, team_pawn)

                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

                    expect(possible_paths).to eq([])
                  end
                end
              end
            end

            context 'moved pawn' do
              before do
                allow(team_pawn).to receive(:move_status).and_return(:moved)
              end

              context 'cells free' do
                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([path(coord_D5)])
                end
              end

              context 'blocked by' do
                context 'same color piece' do
                  it '' do
                    board.add_to_cell_content(coord_D5, enemy_pawn)

                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

                    expect(possible_paths).to eq([])
                  end
                end

                context 'opponent color piece' do
                  it '' do
                    board.add_to_cell_content(coord_D5, team_pawn)

                    board_visualization

                    possible_paths = rules.available_paths_for_piece(testing_position)

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
                  board.add_to_cell_content(coord_E5, team_pawn)
                  board.add_to_cell_content(coord_C5, team_pawn)

                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
                end
              end

              context 'opponent color piece' do
                it '' do
                  board.add_to_cell_content(coord_E5, enemy_pawn)
                  board.add_to_cell_content(coord_C5, enemy_pawn)

                  board_visualization
                  puts board

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([path(coord_D5), path(coord_D6), path(coord_C5),
                                                path(coord_E5)])
                end
              end
            end

            context 'en passant pattern' do
              before do
                allow(enemy_pawn).to receive(:move_status).and_return(:rushed)
              end

              it '' do
                board.add_to_cell_content(coord_E4, enemy_pawn)
                board.add_to_cell_content(coord_C4, enemy_pawn)

                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_D5), path(coord_D6), path(coord_C5),
                                              path(coord_E5)])
              end

              context 'without flank exposed' do
                before do
                  allow(enemy_pawn).to receive(:move_status).and_return(:moved)
                end

                it '' do
                  board.add_to_cell_content(coord_E4, enemy_pawn)
                  board.add_to_cell_content(coord_C4, enemy_pawn)

                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([path(coord_D5), path(coord_D6)])
                end
              end
            end
          end

          context 'when the board has other pieces that limit the knight move' do
            context 'other pieces are attacking the king' do
              before do
                allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
              end

              context 'the piece is already blocking the attack' do
                before do
                  board.add_to_cell_content(coord_D1, team_king)
                  board.add_to_cell_content(coord_D8, enemy_rook)
                end

                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([[coord_D5], [coord_D6]])
                end
              end

              context 'the piece can move to block the attack' do
                before do
                  board.add_to_cell_content(coord_C3, team_king)
                  board.add_to_cell_content(coord_H8, enemy_bishop)
                end
                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(testing_position)

                  expect(possible_paths).to eq([])
                end
              end
            end
          end
        end
      end

      context 'picking a rook' do
        before do
          board.add_to_cell_content(testing_position, team_rook)
        end
        context 'from the middle of a empty board' do
          it '' do
            board_visualization

            possible_paths = rules.available_paths_for_piece(testing_position)

            expect(possible_paths).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4),
                                          path(coord_C4, coord_B4, coord_A4),
                                          path(coord_D5, coord_D6, coord_D7, coord_D8),
                                          path(coord_D3, coord_D2, coord_D1)])
          end
        end

        context 'when the board has other pieces that limit the rook move' do
          context 'other pieces are from the same color' do
            before do
              board.add_to_cell_content(coord_D7, team_pawn)
              board.add_to_cell_content(coord_D3, team_pawn)
              board.add_to_cell_content(coord_F4, team_pawn)
              board.add_to_cell_content(coord_A4, team_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E4),
                                            path(coord_C4, coord_B4),
                                            path(coord_D5, coord_D6)])
            end
          end

          context 'other pieces are from the opposite color' do
            before do
              board.add_to_cell_content(coord_D7, enemy_pawn)
              board.add_to_cell_content(coord_D3, enemy_pawn)
              board.add_to_cell_content(coord_F4, enemy_pawn)
              board.add_to_cell_content(coord_A4, enemy_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E4, coord_F4), path(coord_C4, coord_B4, coord_A4),
                                            path(coord_D5, coord_D6, coord_D7), path(coord_D3)])
            end
          end

          context 'other pieces are attacking the king' do
            before do
              board.add_to_cell_content(coord_D1, team_king)
              allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
            end

            context 'the piece is already blocking the attack' do
              before do
                board.add_to_cell_content(coord_D8, enemy_rook)
              end

              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_D5, coord_D6, coord_D7, coord_D8),
                                              path(coord_D3, coord_D2)])
              end
            end

            context 'the piece can move to block the attack' do
              before do
                board.add_to_cell_content(coord_H5, enemy_bishop)
              end
              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_G4)])
              end
            end
          end
        end
      end

      context 'picking a bishop' do
        before do
          board.add_to_cell_content(testing_position, team_bishop)
        end
        context 'from the middle of a empty board' do
          it '' do
            board_visualization

            possible_paths = rules.available_paths_for_piece(testing_position)

            expect(possible_paths).to eq([path(coord_E5, coord_F6, coord_G7, coord_H8), path(coord_C3, coord_B2, coord_A1),
                                          path(coord_E3, coord_F2, coord_G1), path(coord_C5, coord_B6, coord_A7)])
          end
        end

        context 'when the board has other pieces that limit the bishop move' do
          context 'other pieces are from the same color' do
            before do
              board.add_to_cell_content(coord_G7, team_pawn)
              board.add_to_cell_content(coord_C3, team_pawn)
              board.add_to_cell_content(coord_F2, team_pawn)
              board.add_to_cell_content(coord_A7, team_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E5, coord_F6), path(coord_E3),
                                            path(coord_C5, coord_B6)])
            end
          end

          context 'other pieces are from opposite came color' do
            before do
              board.add_to_cell_content(coord_G7, enemy_pawn)
              board.add_to_cell_content(coord_C3, enemy_pawn)
              board.add_to_cell_content(coord_F2, enemy_pawn)
              board.add_to_cell_content(coord_A7, enemy_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E5, coord_F6, coord_G7), path(coord_C3),
                                            path(coord_E3, coord_F2), path(coord_C5, coord_B6, coord_A7)])
            end
          end

          context 'other pieces are attacking the king' do
            before do
              board.add_to_cell_content(coord_A1, team_king)
              allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
            end

            context 'the piece is already blocking the attack' do
              before do
                board.add_to_cell_content(coord_H8, enemy_queen)
              end

              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_E5, coord_F6, coord_G7, coord_H8),
                                              path(coord_C3, coord_B2)])
              end
            end

            context 'the piece can move to block the attack' do
              before do
                board.add_to_cell_content(coord_H1, enemy_rook)
              end
              it '' do
                board_visualization

                puts board

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_G1)])
              end
            end
          end
        end
      end

      context 'picking a queen' do
        before do
          board.add_to_cell_content(testing_position, team_queen)
        end
        context 'from the middle of a empty board' do
          it '' do
            board_visualization

            possible_paths = rules.available_paths_for_piece(testing_position)

            expect(possible_paths).to eq([path(coord_E4, coord_F4, coord_G4, coord_H4), path(coord_C4, coord_B4, coord_A4),
                                          path(coord_D5, coord_D6, coord_D7, coord_D8), path(coord_D3, coord_D2, coord_D1),
                                          path(coord_E5, coord_F6, coord_G7, coord_H8), path(coord_C3, coord_B2, coord_A1),
                                          path(coord_E3, coord_F2, coord_G1), path(coord_C5, coord_B6, coord_A7)])
          end
        end

        context 'when the board has other pieces that limit the queen move' do
          context 'other pieces are from the same color' do
            before do
              board.add_to_cell_content(coord_D7, team_pawn)
              board.add_to_cell_content(coord_D3, team_pawn)
              board.add_to_cell_content(coord_F4, team_pawn)
              board.add_to_cell_content(coord_A4, team_pawn)
              board.add_to_cell_content(coord_G7, team_pawn)
              board.add_to_cell_content(coord_C3, team_pawn)
              board.add_to_cell_content(coord_F2, team_pawn)
              board.add_to_cell_content(coord_A7, team_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E4), path(coord_C4, coord_B4),
                                            path(coord_D5, coord_D6), path(coord_E5, coord_F6), path(coord_E3), path(coord_C5, coord_B6)])
            end
          end

          context 'other pieces are from opposite came color' do
            before do
              board.add_to_cell_content(coord_D7, enemy_pawn)
              board.add_to_cell_content(coord_D3, enemy_pawn)
              board.add_to_cell_content(coord_F4, enemy_pawn)
              board.add_to_cell_content(coord_A4, enemy_pawn)
              board.add_to_cell_content(coord_G7, enemy_pawn)
              board.add_to_cell_content(coord_C3, enemy_pawn)
              board.add_to_cell_content(coord_F2, enemy_pawn)
              board.add_to_cell_content(coord_A7, enemy_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E4, coord_F4), path(coord_C4, coord_B4, coord_A4),
                                            path(coord_D5, coord_D6, coord_D7), path(coord_D3), path(coord_E5, coord_F6, coord_G7), path(coord_C3), path(coord_E3, coord_F2), path(coord_C5, coord_B6, coord_A7)])
            end
          end

          context 'other pieces are attacking the king' do
            before do
              board.add_to_cell_content(coord_D1, team_king)
              allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
            end

            context 'the piece is already blocking the attack' do
              before do
                board.add_to_cell_content(coord_D8, enemy_rook)
              end

              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_D5, coord_D6, coord_D7, coord_D8),
                                              path(coord_D3, coord_D2)])
              end
            end

            context 'the piece can move to block the attack' do
              before do
                board.add_to_cell_content(coord_H5, enemy_bishop)
              end
              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([path(coord_G4)])
              end
            end
          end
        end
      end

      context 'picking a knight' do
        before do
          board.add_to_cell_content(testing_position, team_knight)
        end

        context 'that is boxed in all around' do
          before do
            board.add_to_cell_content(coord_C3, enemy_rook)
            board.add_to_cell_content(coord_D3, enemy_rook)
            board.add_to_cell_content(coord_E3, enemy_rook)
            board.add_to_cell_content(coord_C4, enemy_rook)
            board.add_to_cell_content(coord_E4, team_rook)
            board.add_to_cell_content(coord_C5, team_rook)
            board.add_to_cell_content(coord_D5, team_rook)
            board.add_to_cell_content(coord_E5, team_rook)
          end

          it '' do
            board_visualization

            possible_paths = rules.available_paths_for_piece(testing_position)

            expect(possible_paths).to eq([path(coord_F5), path(coord_F3), path(coord_E6), path(coord_E2), path(coord_C6), path(coord_C2), path(coord_B5),
                                          path(coord_B3)])
          end
        end

        context 'when the board has other pieces that limit the knight move' do
          context 'other pieces are from the same color' do
            before do
              board.add_to_cell_content(coord_F5, team_pawn)
              board.add_to_cell_content(coord_F3, team_pawn)
              board.add_to_cell_content(coord_E6, team_pawn)
              board.add_to_cell_content(coord_E2, team_pawn)
              board.add_to_cell_content(coord_C6, team_pawn)
              board.add_to_cell_content(coord_C2, team_pawn)
              board.add_to_cell_content(coord_B5, team_pawn)
              board.add_to_cell_content(coord_B3, team_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([])
            end
          end

          context 'other pieces are from the opposite color' do
            before do
              board.add_to_cell_content(coord_F5, enemy_pawn)
              board.add_to_cell_content(coord_F3, enemy_pawn)
              board.add_to_cell_content(coord_E6, enemy_pawn)
              board.add_to_cell_content(coord_E2, enemy_pawn)
              board.add_to_cell_content(coord_C6, enemy_pawn)
              board.add_to_cell_content(coord_C2, enemy_pawn)
              board.add_to_cell_content(coord_B5, enemy_pawn)
              board.add_to_cell_content(coord_B3, enemy_pawn)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_F5), path(coord_F3), path(coord_E6), path(coord_E2), path(coord_C6), path(coord_C2), path(coord_B5),
                                            path(coord_B3)])
            end
          end

          context 'other pieces are attacking the king' do
            before do
              board.add_to_cell_content(coord_D1, team_king)
              allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
            end

            context 'the piece is already blocking the attack' do
              before do
                board.add_to_cell_content(coord_D8, enemy_rook)
              end

              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([])
              end
            end

            context 'the piece can move to block the attack' do
              before do
                board.add_to_cell_content(coord_H5, enemy_bishop)
              end
              it '' do
                board_visualization

                possible_paths = rules.available_paths_for_piece(testing_position)

                expect(possible_paths).to eq([[coord_F3], [coord_E2]])
              end
            end
          end
        end
      end

      context 'picking a king' do
        before do
          allow(Requirement).to receive(:move_is_safe_for_king).and_call_original
        end

        context 'from the middle of a board' do
          context 'with no movement restriction' do
            before do
              board.add_to_cell_content(testing_position, team_king)
            end

            it '' do
              board_visualization

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_E4), path(coord_C4),
                                            path(coord_D5), path(coord_D3),
                                            path(coord_E5), path(coord_C3),
                                            path(coord_E3), path(coord_C5)])
            end
          end

          context 'with restricted movement' do
            before do
              board.add_to_cell_content(testing_position, team_king)
              board.add_to_cell_content(coord_E1, enemy_rook)
            end

            it '' do
              board_visualization
              puts board

              possible_paths = rules.available_paths_for_piece(testing_position)

              expect(possible_paths).to eq([path(coord_C4), path(coord_D5), path(coord_D3),
                                            path(coord_C3), path(coord_C5)])
            end
          end
        end

        context 'in starting position' do
          let(:castle_team_king) { team_king.clone }
          let(:castle_team_rook) { team_rook.clone }

          before do
            board.add_to_cell_content(coord_E1, castle_team_king)
            board.add_to_cell_content(coord_A1, castle_team_rook)
          end

          context 'can castle' do
            it '' do
              board_visualization
              puts board

              possible_paths = rules.available_paths_for_piece(coord_E1)

              expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_E2), path(coord_F2),
                                            path(coord_D2), path(coord_C1)]))
            end
          end

          context 'can\'t castle' do
            context 'because king and/or rook already moved' do
              context 'when king has moved' do
                before do
                  castle_team_king.mark_as_moved
                end

                it '' do
                  possible_paths = rules.available_paths_for_piece(coord_E1)

                  expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_E2), path(coord_F2),
                                                path(coord_D2)]))
                end
              end

              context 'when rook has moved' do
                before do
                  castle_team_rook.mark_as_moved
                end

                it '' do
                  possible_paths = rules.available_paths_for_piece(coord_E1)

                  expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_E2), path(coord_F2),
                                                path(coord_D2)]))
                end
              end
            end

            context 'any cell involved are under attack' do
              context 'king targeted' do
                before do
                  board.add_to_cell_content(coord_E8, enemy_rook)
                end
                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(coord_E1)

                  expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_F2),
                                                path(coord_D2)]))
                end
              end
              context 'row targeted' do
                before do
                  board.add_to_cell_content(coord_C8, enemy_rook)
                end
                it '' do
                  board_visualization

                  possible_paths = rules.available_paths_for_piece(coord_E1)

                  expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_E2), path(coord_F2),
                                                path(coord_D2)]))
                end
              end
            end
            context 'one of the cells are not empty' do
              before do
                board.add_to_cell_content(coord_C1, team_bishop)
              end
              it '' do
                board_visualization
                puts board

                possible_paths = rules.available_paths_for_piece(coord_E1)

                expect(possible_paths).to(eq([path(coord_F1), path(coord_D1), path(coord_E2), path(coord_F2),
                                              path(coord_D2)]))
              end
            end
          end
        end
      end
    end

    describe '#possible_flanks_for_en_passant' do
      before do
        allow(Requirement).to receive(:move_is_safe_for_king).and_return(proc { true })
        board.add_to_cell_content(testing_position, team_pawn)
        board.add_to_cell_content(coord_E4, enemy_pawn)
        board.add_to_cell_content(coord_C4, enemy_pawn)
      end
      context 'with flank exposed' do
        before do
          allow(enemy_pawn).to receive(:move_status).and_return(:rushed)
        end

        it '' do
          board_visualization

          possible_flanks = rules.possible_flanks_for_en_passant(testing_position)

          expect(possible_flanks).to eq([{ flank: coord_C5, target: coord_C4 }, { flank: coord_E5, target: coord_E4 }])
        end
      end

      context 'without flank exposed' do
        before do
          allow(enemy_pawn).to receive(:move_status).and_return(:moved)
        end

        it '' do
          board_visualization

          possible_flanks = rules.possible_flanks_for_en_passant(testing_position)

          expect(possible_flanks).to eq([])
        end
      end
    end
  end
end
