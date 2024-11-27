require_relative '../lib/chess_kit/pieces/unit'

describe Unit do
  subject(:a_unit) { described_class.new(color_dbl, type_dbl) }
  let(:color_dbl) { double('random color') }
  let(:type_dbl) { double('random type') }

  describe '#move_status' do
    context 'for a general piece' do
      context "when the piece hasn't been moved" do
        it 'is expected to return :unmoved' do
          expect(a_unit.move_status).to eq(:unmoved)
        end
      end
      context 'when the piece has made some moves' do
        context '#mark_as_moved' do
          let(:moved_piece) { a_unit }

          before do
            moved_piece.mark_as_moved
          end

          it 'is expected to return :moved' do
            expect(moved_piece.move_status).to eq(:moved)
          end
        end
      end
    end
  end
end
