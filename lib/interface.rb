# frozen_string_literal: true

module Interface
  def self.prompt_for_name; end

  module Output
    require 'rainbow'

    COLOR_PALETTE = { white: :snow, black: :black, dark: :darkslategray, light: '#8A6241' }.freeze

    PIECE_BLUEPRINT = { pawn: "\u265F",
                        rook: "\u265C",
                        knight: "\u265E",
                        bishop: "\u265D",
                        queen: "\u265B",
                        king: "\u265A" }.freeze

    DISPLAY_BLOCK_SIZE = 3

    def self.render_piece(unit)
      unit_blueprint = padded_content(PIECE_BLUEPRINT[unit.type])
      unit_canvas = Rainbow(unit_blueprint)
      unit_canvas.color(COLOR_PALETTE[unit.color])
    end

    def self.render_game(board)
      head_label = columns_label(board)
      body = render_board(board)
      bottom_label = head_label

      head_label + body + bottom_label
    end

    def self.padded_content(content)
      content.to_s.center(DISPLAY_BLOCK_SIZE)
    end

    def self.empty_display_block
      padded_content('')
    end

    def self.columns_label(board)
      column_count = board.board_width
      column_names = ('A'..'Z').first(column_count)
      padded_labels = column_names.map { |column_name| padded_content(column_name) }
      label = padded_labels.join

      empty_display_block + label + empty_display_block + "\n"
    end

    def self.render_board(board)
      rows = []

      board.cells.each_with_index do |row, row_index|
        row_label = padded_content(row_index + 1)
        row_cells = render_row_cells(row, row_index)

        row_full_line = "#{row_label}#{row_cells}#{row_label}\n"
        rows.append(row_full_line)
      end
      rows.reverse.join # reverse because the boards depth is from closest to furthest
    end

    def self.render_row_cells(row, row_index)
      row_cells = []

      row.each_with_index do |cell_content, cell_number|
        content_blueprint = padded_content(cell_content)
        content_canvas = Rainbow(content_blueprint)
        background_color = (row_index + cell_number).even? ? COLOR_PALETTE[:dark] : COLOR_PALETTE[:light]
        content_with_tile_color = content_canvas.bg(background_color)

        row_cells.append(content_with_tile_color)
      end
      row_cells.join
    end
  end
end
