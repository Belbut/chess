module MovePattern 

  module MovementCalculations
    def generate_pattern(radius, &direction) 
      result = []
      (1..radius).each do |i|
        result.concat(direction.call(i))
      end
      result
    end

    def diagonals_proc
      Proc.new { |i| [[i,i],[-i,i],[-i,-i],[i,-i]]}
    end

    def orthogonals_proc
      Proc.new { |i| [[i,0],[0,i],[-i,0],[0,-i]]}
    end

    def omnidirectional_proc
      Proc.new { |i| (orthogonals_proc.call(i) + diagonals_proc.call(i))}
    end
  end

  extend MovementCalculations

  ROOK_MOVE_PATTERN = generate_pattern(7, &orthogonals_proc).freeze
  KNIGHT_MOVE_PATTERN = [[+2, 1], [+2, -1], [+1, +2], [+1, -2],
                        [-1, +2], [-1, -2], [-2, 1], [-2, -1]].freeze
  BISHOP_MOVE_PATTERN = generate_pattern(7, &diagonals_proc).freeze
  QUEEN_MOVE_PATTERN = generate_pattern(7,&omnidirectional_proc).freeze
  KING_MOVE_PATTERN = generate_pattern(1,&omnidirectional_proc).freeze

  # STANDARD VALUES FOR WHITE PIECES, BLACK PAWN INVERT THE YY VALUE
  MOVED_PAWN_MOVE_PATTERN = [[0,1]].freeze
  UNMOVED_PAWN_MOVE_PATTERN = [[0,1],[0,2]].freeze
  PAWN_CAPTURE_PATTERN = [[-1,1],[1,1]].freeze

  CASTLE_ACTION_KING_PATTERN = [[-2,0],[2,0]].freeze
  CASTLE_ACTION_ROOK_PATTERN = [[3,0],[-2,0]].freeze

  MOVE_FACTORY = {rook:MovePattern::ROOK_MOVE_PATTERN,
                    knight:MovePattern::KNIGHT_MOVE_PATTERN,
                    bishop:MovePattern::BISHOP_MOVE_PATTERN,
                    queen:MovePattern::QUEEN_MOVE_PATTERN,
                    king:MovePattern::KING_MOVE_PATTERN}.freeze
end
