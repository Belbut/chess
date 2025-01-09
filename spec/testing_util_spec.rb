# frozen_string_literal: true

require_relative '../lib/chess_kit/coordinate'
module TestingUtil
  ('A'..'H').each do |columns_letter| # 'A' to 'H' (columns)
    (1..8).each do |row_index| # 1 to 8 (rows)
      define_method("coord_#{columns_letter}#{row_index}") do
        Coordinate.from_notation("#{columns_letter}#{row_index}")
      end
    end
  end
end
