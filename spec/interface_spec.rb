# frozen_string_literal: true

require_relative '../lib/interface'
require_relative '../lib/chess_kit/pieces/unit'
require_relative '../lib/chess_kit/board'

PIECE_RENDERED = { white: { pawn: "\e[38;5;231m ♟ \e[0m",
                            rook: "\e[38;5;231m ♜ \e[0m",
                            knight: "\e[38;5;231m ♞ \e[0m",
                            bishop: "\e[38;5;231m ♝ \e[0m",
                            queen: "\e[38;5;231m ♛ \e[0m",
                            king: "\e[38;5;231m ♚ \e[0m" },

                   black: { pawn: "\e[30m ♟ \e[0m",
                            rook: "\e[30m ♜ \e[0m",
                            knight: "\e[30m ♞ \e[0m",
                            bishop: "\e[30m ♝ \e[0m",
                            queen: "\e[30m ♛ \e[0m",
                            king: "\e[30m ♚ \e[0m" } }.freeze

describe Interface do
  describe Interface::Output do
    describe '.render_piece' do
      let(:unit_dbl) { instance_double(Unit) }
      before do
        allow(unit_dbl).to receive(:color).and_return(context_color)
        allow(unit_dbl).to receive(:type).and_return(context_type)
      end

      context 'when the piece is a' do
        context 'white' do
          let(:context_color) { :white }

          context 'pawn' do
            let(:context_type) { :pawn }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'rook' do
            let(:context_type) { :rook }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'knight' do
            let(:context_type) { :knight }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'bishop' do
            let(:context_type) { :bishop }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'queen' do
            let(:context_type) { :queen }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'king' do
            let(:context_type) { :king }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end
        end

        context 'black' do
          let(:context_color) { :black }

          context 'pawn' do
            let(:context_type) { :pawn }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'rook' do
            let(:context_type) { :rook }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'knight' do
            let(:context_type) { :knight }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'bishop' do
            let(:context_type) { :bishop }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'queen' do
            let(:context_type) { :queen }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end

          context 'king' do
            let(:context_type) { :king }

            it do
              piece_render = PIECE_RENDERED[context_color][context_type]
              expect(subject.render_piece(unit_dbl)).to eq(piece_render)
            end
          end
        end
      end
    end

    describe '.render_game' do
      let(:board_dbl) { instance_double(Board) }
      subject(:board_render) { described_class.render_game(board_dbl) }

      let(:head_label) { board_render.lines.first }
      let(:board_render_body) { board_render.lines[1...-1] }
      let(:bottom_label) { board_render.lines.last }

      context 'does it render the board' do
        let(:label_5_columns) { '   ' + ' A  B  C  D  E ' + '   ' + "\n" }
        let(:label_8_columns) { '   ' + ' A  B  C  D  E  F  G  H ' + '   ' + "\n" }

        context 'when the board is a 5x8 board' do
          let(:height) { 5 }
          let(:width) { 8 }

          before do
            allow(board_dbl).to receive(:board_height).and_return(height)
            allow(board_dbl).to receive(:board_width).and_return(width)
          end

          context 'top column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(head_label).to eq label_8_columns
            end
          end

          context 'body of the board' do
            context 'when the board is empty' do
              let(:empty_board_matrix) { Array.new(height) { Array.new(width) } }

              before do
                allow(board_dbl).to receive(:matrix).and_return empty_board_matrix
              end

              context 'does it have the correct number of rows' do
                it do
                  expect(board_render_body.size).to eq board_dbl.board_height
                end
              end

              it 'is expected to have the correct background color' do
                color_switch = { light_bg: { block: "\e[48;5;137m   \e[0m", next: :dark_bg },
                                 dark_bg: { block: "\e[48;5;59m   \e[0m", next: :light_bg } }

                board_render_body.each_with_index do |row_content, index|
                  board_row_content = row_content.chomp[3...-3] # removes line break and row label
                  # inverted to reflect that the (0,0) on board is the top left of the matrix and on the display is the bottom left
                  bg_color = (height - index).odd? ? :dark_bg : :light_bg

                  expected_row = ''
                  width.times do
                    expected_row += color_switch[bg_color][:block]
                    bg_color = color_switch[bg_color][:next]
                  end
                  puts "#{' ' * 15}#{expected_row}"
                  expect(board_row_content).to eq expected_row
                end
              end

              context 'correct row label' do
                context 'on first display block' do
                  it 'is expected to display a decreasing index of row' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to start_with(" #{row_label} ")
                      row_label -= 1
                    end
                  end
                end

                context 'on last display block' do
                  it 'is expected to display a decreasing index of row and line break' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to end_with(" #{row_label} \n")
                      row_label -= 1
                    end
                  end
                end
              end
            end
          end

          context 'bottom column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(bottom_label).to eq label_8_columns
            end
          end
        end

        context 'when the board is a 8x5 board' do
          let(:height) { 8 }
          let(:width) { 5 }

          before do
            allow(board_dbl).to receive(:board_height).and_return(height)
            allow(board_dbl).to receive(:board_width).and_return(width)
          end

          context 'top column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(head_label).to eq label_5_columns
            end
          end

          context 'body of the board' do
            context 'when the board is empty' do
              let(:empty_board_matrix) { Array.new(height) { Array.new(width) } }

              before do
                allow(board_dbl).to receive(:matrix).and_return empty_board_matrix
              end

              context 'does it have the correct number of rows' do
                it do
                  expect(board_render_body.size).to eq board_dbl.board_height
                end
              end

              it 'is expected to have the correct background color' do
                color_switch = { light_bg: { block: "\e[48;5;137m   \e[0m", next: :dark_bg },
                                 dark_bg: { block: "\e[48;5;59m   \e[0m", next: :light_bg } }

                board_render_body.each_with_index do |row_content, index|
                  board_row_content = row_content.chomp[3...-3] # removes line break and row label
                  # inverted to reflect that the (0,0) on board is the top left of the matrix and on the display is the bottom left
                  bg_color = (height - index).odd? ? :dark_bg : :light_bg

                  expected_row = ''
                  width.times do
                    expected_row += color_switch[bg_color][:block]
                    bg_color = color_switch[bg_color][:next]
                  end
                  puts "#{' ' * 15}#{expected_row}"
                  expect(board_row_content).to eq expected_row
                end
              end

              context 'correct row label' do
                context 'on first display block' do
                  it 'is expected to display a decreasing index of row' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to start_with(" #{row_label} ")
                      row_label -= 1
                    end
                  end
                end

                context 'on last display block' do
                  it 'is expected to display a decreasing index of row and line break' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to end_with(" #{row_label} \n")
                      row_label -= 1
                    end
                  end
                end
              end
            end
          end

          context 'bottom column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(bottom_label).to eq label_5_columns
            end
          end
        end

        context 'when the board is a 8x8 board' do
          let(:height) { 8 }
          let(:width) { 8 }

          before do
            allow(board_dbl).to receive(:board_height).and_return(height)
            allow(board_dbl).to receive(:board_width).and_return(width)
          end

          context 'top column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(head_label).to eq label_8_columns
            end
          end

          context 'body of the board' do
            context 'when the board is empty' do
              let(:empty_board_matrix) { Array.new(height) { Array.new(width) } }

              before do
                allow(board_dbl).to receive(:matrix).and_return empty_board_matrix
              end

              context 'does it have the correct number of rows' do
                it do
                  expect(board_render_body.size).to eq board_dbl.board_height
                end
              end

              it 'is expected to have the correct background color' do
                color_switch = { light_bg: { block: "\e[48;5;137m   \e[0m", next: :dark_bg },
                                 dark_bg: { block: "\e[48;5;59m   \e[0m", next: :light_bg } }

                board_render_body.each_with_index do |row_content, index|
                  board_row_content = row_content.chomp[3...-3] # removes line break and row label
                  # inverted to reflect that the (0,0) on board is the top left of the matrix and on the display is the bottom left
                  bg_color = (height - index).odd? ? :dark_bg : :light_bg

                  expected_row = ''
                  width.times do
                    expected_row += color_switch[bg_color][:block]
                    bg_color = color_switch[bg_color][:next]
                  end
                  puts "#{' ' * 15}#{expected_row}"
                  expect(board_row_content).to eq expected_row
                end
              end

              context 'correct row label' do
                context 'on first display block' do
                  it 'is expected to display a decreasing index of row' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to start_with(" #{row_label} ")
                      row_label -= 1
                    end
                  end
                end

                context 'on last display block' do
                  it 'is expected to display a decreasing index of row and line break' do
                    row_label = height
                    board_render_body.each do |row_content|
                      expect(row_content).to end_with(" #{row_label} \n")
                      row_label -= 1
                    end
                  end
                end
              end
            end
          end

          context 'bottom column labels' do
            before do
              allow(described_class).to receive(:render_board).and_return("empty body \n")
            end
            it '' do
              expect(bottom_label).to eq label_8_columns
            end
          end
        end
      end
    end
  end
end
