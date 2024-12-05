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

    def self.render_board(board)
      head_label = columns_label(board)
      body = render_body(board)
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

    def self.render_body(board)
      body = []
      board_by_row = board.cells
      board_by_row.each_with_index do |row, index|
        row_label = padded_content(board.board_height - index)
        row_display = []
        row.each_with_index do |cell_content, index2|
          content_blueprint = padded_content(cell_content)
          content_canvas = Rainbow(content_blueprint)

          background_color = (index + index2).odd? ? COLOR_PALETTE[:dark] : COLOR_PALETTE[:light]
          content_with_tile_color = content_canvas.bg(background_color)
          row_display.append(content_with_tile_color)
        end
        body_line = "#{row_label}#{row_display.join}#{row_label}\n"
        body.append(body_line)
      end
      body.join
    end
  end
end

# " 8 \e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m 8 \n 7 \e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m 7 \n 6 \e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m 6 \n 5 \e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m 5 \n 4 \e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m 4 \n 3 \e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m 3 \n 2 \e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m 2 \n 1 \e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m\e[48;5;59m   \e[0m\e[48;5;137m   \e[0m 1 \n"
