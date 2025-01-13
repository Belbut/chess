# frozen_string_literal: true

require_relative '../lib/chess_kit/coordinate'
require_relative '../lib/chess_kit/pieces'
module TestingUtil
  ('A'..'H').each do |columns_letter| # 'A' to 'H' (columns)
    (1..8).each do |row_index| # 1 to 8 (rows)
      define_method("coord_#{columns_letter}#{row_index}") do
        Coordinate.from_notation("#{columns_letter}#{row_index}")
      end
    end
  end

  def enemy_pawn
    Pieces::FACTORY[enemy_color][:pawn]
  end

  def enemy_rook
    Pieces::FACTORY[enemy_color][:rook]
  end

  def enemy_knight
    Pieces::FACTORY[enemy_color][:knight]
  end

  def enemy_bishop
    Pieces::FACTORY[enemy_color][:bishop]
  end

  def enemy_queen
    Pieces::FACTORY[enemy_color][:queen]
  end

  def enemy_king
    Pieces::FACTORY[enemy_color][:king]
  end

  def team_pawn
    Pieces::FACTORY[team_color][:pawn]
  end

  def team_rook
    Pieces::FACTORY[team_color][:rook]
  end

  def team_knight
    Pieces::FACTORY[team_color][:knight]
  end

  def team_bishop
    Pieces::FACTORY[team_color][:bishop]
  end

  def team_queen
    Pieces::FACTORY[team_color][:queen]
  end

  def team_king
    Pieces::FACTORY[team_color][:king]
  end

  def team_piece
    Pieces::FACTORY[team_color][:king]
  end

  def enemy_blocking_piece
    Pieces::FACTORY[enemy_color][:pawn]
  end

  def friendly_blocking_piece
    Pieces::FACTORY[team_color][:pawn]
  end

  def testing_position
    coord_D4
  end
end
