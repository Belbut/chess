# frozen_string_literal: true

require_relative '../lib/interface'
require_relative '../lib/chess_kit/pieces/unit'

describe Interface do
  describe Interface::Output do
    describe '.render_piece' do
      let(:unit_dbl) { instance_double(Unit) }
      before do
        allow(unit_dbl).to receive(:color).and_return(context_color)
        allow(unit_dbl).to receive(:type).and_return(context_type)
      end

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
                                  king: "\e[30m ♚ \e[0m" } }

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
  end
end
