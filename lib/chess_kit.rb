# frozen_string_literal: true

class ChessKit
  attr_reader :board



  # rows = height
  # columns = width
  BOARD_SIZE = { rows: 8, columns: 8 }.freeze

  def initialize
    @board = Array.new(BOARD_SIZE[:rows]) { BOARD_SIZE[:columns] }
  end
end
