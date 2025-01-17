# frozen_string_literal: true

require_relative '../lib/chess_kit/pieces/pawn'
require_relative '../lib/chess_kit/pieces/noble_pieces'

describe Pieces do
  let(:color_dbl) { double('random color') }

  describe Pieces::Pawn do
    subject(:pawn) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(pawn.type).to eq :pawn
      end
    end

    describe '#move_pattern' do
      # context "when the pawn hasn't moved before" do
      #   xit 'is expected to have the possibility to rush' do
      #     expect(pawn.move_pattern.sort).to eq UNMOVED_PAWN_MOVE_PATTERN.sort
      #   end
      # end

      # context 'when the pawn has moved before' do
      #   before do
      #     pawn.mark_as_moved
      #   end

      #   xit 'is expected to only move one square' do
      #     expect(pawn.move_pattern.sort).to eq MOVED_PAWN_MOVE_PATTERN.sort
      #   end
      # end

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

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(pawn.capture_pattern.sort).to eq PAWN_CAPTURE_PATTERN.sort
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(pawn).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{pawn}"
        expect(pawn.to_s).to eq "\e[38;5;231m ♟ \e[0m"
      end
      it 'of black piece' do
        allow(pawn).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{pawn}"
        expect(pawn.to_s).to eq "\e[30m ♟ \e[0m"
      end
    end
  end

  describe Pieces::Rook do
    subject(:rook) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(rook.type).to eq :rook
      end
    end

    # describe '#move_pattern' do
    #   xit 'is expected to store all the possible rook moves' do
    #     expect(rook.move_pattern.sort).to eq ROOK_MOVE_PATTERN.sort
    #   end
    # end

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(rook.capture_pattern).to eq rook.move_pattern
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(rook).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{rook}"
        expect(rook.to_s).to eq "\e[38;5;231m ♜ \e[0m"
      end

      it 'of black piece' do
        allow(rook).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{rook}"
        expect(rook.to_s).to eq "\e[30m ♜ \e[0m"
      end
    end
  end

  describe Pieces::Knight do
    subject(:knight) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(knight.type).to eq :knight
      end
    end

    # describe '#move_pattern' do
    #   xit 'is expected to store all the possible knight moves' do
    #     expect(knight.move_pattern.sort).to eq KNIGHT_MOVE_PATTERN.sort
    #   end
    # end

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(knight.capture_pattern).to eq knight.move_pattern
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(knight).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{knight}"
        expect(knight.to_s).to eq "\e[38;5;231m ♞ \e[0m"
      end

      it 'of black piece' do
        allow(knight).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{knight}"
        expect(knight.to_s).to eq "\e[30m ♞ \e[0m"
      end
    end
  end

  describe Pieces::Bishop do
    subject(:bishop) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(bishop.type).to eq :bishop
      end
    end

    # describe '#move_pattern' do
    #   xit 'is expected to store all the possible bishop moves' do
    #     expect(bishop.move_pattern.sort).to eq BISHOP_MOVE_PATTERN.sort
    #   end
    # end

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(bishop.capture_pattern).to eq bishop.move_pattern
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(bishop).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{bishop}"
        expect(bishop.to_s).to eq "\e[38;5;231m ♝ \e[0m"
      end

      it 'of black piece' do
        allow(bishop).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{bishop}"
        expect(bishop.to_s).to eq "\e[30m ♝ \e[0m"
      end
    end
  end

  describe Pieces::Queen do
    subject(:queen) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(queen.type).to eq :queen
      end
    end

    # describe '#move_pattern' do
    #   xit 'is expected to store all the possible queen moves' do
    #     expect(queen.move_pattern.sort).to eq QUEEN_MOVE_PATTERN.sort
    #   end
    # end

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(queen.capture_pattern).to eq queen.move_pattern
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(queen).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{queen}"
        expect(queen.to_s).to eq "\e[38;5;231m ♛ \e[0m"
      end

      it 'of black piece' do
        allow(queen).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{queen}"
        expect(queen.to_s).to eq "\e[30m ♛ \e[0m"
      end
    end
  end

  describe Pieces::King do
    subject(:king) { described_class.new(color_dbl) }

    describe '#type' do
      it do
        expect(king.type).to eq :king
      end
    end

    # describe '#move_pattern' do
    #   xit 'is expected to store all the possible king moves' do
    #     expect(king.move_pattern.sort).to eq KING_MOVE_PATTERN.sort
    #   end
    # end

    # describe '#capture_pattern' do
    #   xit 'is expected to be the same as @move_pattern' do
    #     expect(king.capture_pattern).to eq king.move_pattern
    #   end
    # end

    describe '#to_s' do
      it 'of white piece' do
        allow(king).to receive(:color).and_return(:white)
        puts "#{' ' * 5}#{king}"
        expect(king.to_s).to eq "\e[38;5;231m ♚ \e[0m"
      end

      it 'of black piece' do
        allow(king).to receive(:color).and_return(:black)
        puts "#{' ' * 5}#{king}"
        expect(king.to_s).to eq "\e[30m ♚ \e[0m"
      end
    end
  end
end
