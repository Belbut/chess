# frozen_string_literal: true

module Interface
  GAME_GREETING = <<~ASCII
         ___      _ _           _   _        ___ _#{'                   '}
        / __\\ ___| | |__  _   _| |_( )__    / __\\ |__   ___  ___ ___#{' '}
       /__\\/// _ \\ | '_ \\| | | | __|/ __|  / /  | '_ \\ / _ \\/ __/ __|
      / \\/  \\  __/ | |_) | |_| | |_ \\__ \\ / /___| | | |  __/\\__ \\__ \\
      \\_____/\\___|_|_.__/ \\__,_|\\__||___/ \\____/|_| |_|\\___||___/___/

    Welcome to Terminal Chess
    This is a command-line chess game where you can play against another player or the computer
    You can start a new game or load a previously saved one

  ASCII

  def self.game_greeting
    reset_terminal_display
    puts GAME_GREETING
    sleep(1)
  end

  def self.new_match_intro
    puts 'First lets create each players'
  end

  def self.load_or_new_game
    puts 'Would you like to load a saved game or play a new one? (new/load)'
    response = prompt_standardized_input(%w[new load])
    reset_terminal_display

    if response == 'load'
      puts "Let's resume the last game"
      :load_game
    else
      puts "Let's play a new game"
      :new_game
    end
  end

  def self.get_round_moves(chess_kit, rules)
    display_chess_board(chess_kit)

    puts "Turn ##{chess_kit.full_move_count}: #{chess_kit.current_color_name.capitalize} move:"

    move_from = get_piece_to_pick_up(chess_kit, rules)
    display_possible_moves(move_from, chess_kit, rules)

    move_to = get_target_cell(rules, move_from)
    clean_cell_states(chess_kit) # needed after the display_possible_moves
    [move_from, move_to]
  end

  def self.display_possible_moves(move_from, chess_kit, rules)
    possible_moves_from = rules.available_paths_for_piece(move_from).flatten

    chess_kit.board.add_to_cell_state(move_from, :picked)

    en_passant_especial_cases = rules.possible_flanks_for_en_passant(move_from)

    possible_moves_from.each do |coord|
      if chess_kit.board.lookup_cell_content(coord).nil?
        # if the move is a an passant move -> movable to the other side
        if en_passant_especial_cases.map { |en_passant_case| en_passant_case[:flank] }.include?(coord)
          chess_kit.board.add_to_cell_state(coord, :flankable)
        else
          chess_kit.board.add_to_cell_state(coord, :movable)
        end
      else
        chess_kit.board.add_to_cell_state(coord, :capturable)
      end
    end
    display_chess_board(chess_kit)
  end

  def self.clean_cell_states(chess_kit)
    chess_kit.board.remove_all_cell_states
  end

  def self.get_piece_to_pick_up(chess_kit, rules)
    puts "Select a piece to move (e.g., 'e2' for the piece at e2):"

    loop do
      move_from = prompt_for_coordinate_notation

      unless chess_kit.current_player_owns_piece_at?(move_from)
        puts "The cell #{move_from.to_notation} doesn't have your piece, pick again"
        next
      end
      return move_from unless rules.available_paths_for_piece(move_from).empty?

      puts "The piece in #{move_from.to_notation} can't move, pick another"
    end
  end

  def self.get_target_cell(rules, move_from)
    possible_moves_from = rules.available_paths_for_piece(move_from).flatten

    puts "Enter the destination square (e.g., 'e4') or type 'change' to pick a different piece:"
    loop do
      move_to = prompt_for_coordinate_notation

      return move_to if possible_moves_from.include?(move_to)

      puts "The target move #{move_to.to_notation} is not possible, pick another !!!!!!!or pick another piece:"
    end
  end

  def self.display_chess_board(chess_kit)
    reset_terminal_display
    puts 'FEN: ' + chess_kit.to_fen + "\n"
    puts "\n"

    puts chess_kit
    puts "\n"
  end

  def self.prompt_for_name(color)
    puts "\nWho will be playing as the #{color.capitalize} pieces? (Type 'AI' if you want the computer to play.)"
    prompt_standardized_input(['AI'], no_constrains: true).capitalize
  end

  def self.reset_terminal_display
    system('clear') || system('cls')
  end

  # standard should be an array with
  def self.prompt_standardized_input(standard = [], no_constrains: false, case_sensitive: false)
    loop do
      print '  -> '
      input = case_sensitive ? gets.chomp : gets.chomp.downcase

      return input if standard.any?(input) || no_constrains

      puts "Your input \"#{input}\" doesn't fit inside the possible answers \"#{standard.join(', ')}\" so try and pick one of them"
    end
  end

  def self.prompt_for_coordinate_notation
    Coordinate.from_notation(prompt_standardized_input(no_constrains: true))
  rescue ArgumentError => e
    puts e
    puts "Chose again, (e.g., 'e2' for the piece at e2)"
    prompt_for_coordinate_notation
  end

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

      board.matrix.each_with_index do |row, row_index|
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

        case cell_content.state
        when :picked
          content_with_tile_color = content_with_tile_color.blink
        when :capturable, :flankable
          content_with_tile_color = content_canvas.bg(:red)
        when :movable
          content_with_tile_color = content_with_tile_color.sub(padded_content(cell_content),
                                                                padded_content('x'))
        end

        row_cells.append(content_with_tile_color)
      end
      row_cells.join
    end
  end
end
