# frozen_string_literal: true

module Interface
  module Input
    # standard should be an array with strings of standard expected input
    def self.prompt_standardized_input(standard = [], no_constrains: false, case_sensitive: false)
      loop do
        print '  -> '
        input = case_sensitive ? gets.chomp : gets.chomp.downcase

        return input if standard.any?(input) || no_constrains

        puts "Your input \"#{input}\" doesn't fit inside the possible answers \"#{standard.join(', ')}\" so try and pick one of them"
      end
    end

    def self.prompt_first_action
      player_input = prompt_standardized_input(%w[save quit], no_constrains: true)
      return :save if player_input == 'save'
      return :quit if player_input == 'quit'

      prompt_for_coordinate_notation(player_input) { prompt_first_action }
    end

    def self.prompt_for_coordinate_notation(player_input)
      Coordinate.from_notation(player_input)
    rescue ArgumentError, RangeError => e
      puts e
      puts "Chose again, (e.g., 'e2' for the piece at e2)"
      yield
    end

    def self.prompt_for_name(color)
      puts "\nWho will be playing as the #{color.capitalize} pieces? (Type 'AI' if you want the computer to play.)"
      prompt_standardized_input(['AI'], no_constrains: true).capitalize
    end

    module FlowHandler
      def self.load_or_new_match
        puts 'Would you like to load a saved game or play a new one? (new/load)'
        response = Interface::Input.prompt_standardized_input(%w[new load])
        Interface::Output.reset_terminal_display

        if response == 'load'
          puts "Let's resume the last game"
          :load_match
        else
          puts "Let's play a new game"
          :new_match
        end
      end

      def self.get_round_moves(game)
        chess_kit = game.chess_kit
        rules = game.rules

        Interface::Output::Visualizer.display_game(chess_kit)
        puts "Turn ##{chess_kit.full_move_count}: #{chess_kit.current_color_name.capitalize} move:"

        human_player_round(game)
      end

      def self.human_player_round(game)
        chess_kit = game.chess_kit
        rules = game.rules

        move_from = determine_initial_move(game)

        move_to = get_target_cell(rules, move_from)
        chess_kit.clean_cell_states # needed after the display_possible_moves_on_board

        if move_to == :change
          get_round_moves(game)
        else
          [move_from, move_to]
        end
      end

      def self.determine_initial_move(game)
        chess_kit = game.chess_kit
        rules = game.rules

        move_from = get_piece_to_pick_up(game)
        Interface::Output::Visualizer.display_possible_moves_on_board(move_from, chess_kit, rules)

        move_from
      end

      def self.get_piece_to_pick_up(game)
        puts "Select a piece to move (e.g., 'e2' for the piece at e2):"
        puts "or you can 'save' or 'quit' the game"

        loop do
          first_action = Interface::Input.prompt_first_action

          case first_action
          when :quit
            handle_surrender_action(game)
          when :save
            handle_saving_action(game) and next # always executes
          else
            handle_move_action(game, first_action) && (return first_action) # only if something is returned it executes flow fu
          end
        end
      end

      def self.handle_move_action(game, first_action)
        chess_kit = game.chess_kit
        rules = game.rules

        unless chess_kit.board.inside_board?(first_action)
          return puts "The #{first_action.to_notation} isn't inside the board, pick another"
        end

        unless chess_kit.current_player_owns_piece_at?(first_action)
          return puts "The cell #{first_action.to_notation} doesn't have your piece, pick again"
        end

        if rules.available_paths_for_piece(first_action).empty?
          return puts "The piece in #{first_action.to_notation} can't move, pick another"
        end

        first_action
      end

      def self.handle_saving_action(game)
        puts 'Saving the present game ...'
        game.save
        sleep(2)
        puts 'Game saved you can continue to play:'
      end

      def self.handle_surrender_action(game)
        puts 'You decided to surrender.'
        game.rules.game_state = :surrender
        throw :surrender
      end

      def self.get_target_cell(rules, move_from)
        possible_moves_from = rules.available_paths_for_piece(move_from).flatten

        puts "Enter the destination square (e.g., 'e4') or type 'change' to pick a different piece:"
        loop do
          move_to = prompt_target_cell

          return :change if move_to == :change
          return move_to if possible_moves_from.include?(move_to)

          puts "The target move #{move_to.to_notation} is not possible, pick another !!!!!!!or pick another piece:"
        end
      end

      def self.prompt_target_cell
        player_input = Interface::Input.prompt_standardized_input(['change'], no_constrains: true)
        return :change if player_input == 'change'

        Interface::Input.prompt_for_coordinate_notation(player_input) { prompt_target_cell }
      end
    end
  end

  module Output
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

    def self.new_match_intro(chess_kit)
      puts 'Lets play a new game! this is the board:'
      Interface::Output::Visualizer.display_game(chess_kit)
      puts 'Now lets create each player'
    end

    def self.load_match_intro(chess_kit)
      puts 'Lets continue the last saved game'
      puts 'This is the state of the game when you saved:'
      Interface::Output::Visualizer.display_game(chess_kit)
      puts 'Now decide who will be playing with each color, this is a great opportunity if you want to change sides'
    end

    def self.players_created_intro(white_player_name, black_player_name)
      puts("\nGame setup complete. \"#{white_player_name}\" will play as White, and \"#{black_player_name}\" will play as Black.")
    end

    def self.reset_terminal_display
      system('clear') || system('cls')
    end

    def self.end_game_message(game)
      game_state = game.rules.game_state

      if game_state == :checkmate
        checkmate_message(game)
      elsif game_state == :surrender
        surrender_message(game)
      else
        draw_message(game_state)
      end
    end

    def self.checkmate_message(game)
      current_player_color_name = game.chess_kit.current_color_name
      puts "The #{current_player_color_name} is checkmated!"

      announce_winner(game)
    end

    def self.surrender_message(game)
      announce_winner(game)
    end

    def self.announce_winner(game)
      current_player_color_name = game.chess_kit.current_color_name
      winner_color_name = ChessKit.opposite_color(current_player_color_name)
      winner_name = Player.name_from_color(game, winner_color_name)

      puts "Congratulations #{winner_name}"
    end

    def self.check_message
      puts 'Check!'
    end

    def self.draw_message(draw_reason)
      puts "Because of #{draw_reason}, the game ended in a draw!"
    end

    module Visualizer
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

      def self.display_game(chess_kit)
        Interface::Output.reset_terminal_display
        puts 'FEN: ' + chess_kit.to_fen + "\n"
        puts "\n"

        puts chess_kit
        puts "\n"
      end

      def self.display_possible_moves_on_board(move_from, chess_kit, rules)
        possible_moves_from = rules.available_paths_for_piece(move_from).flatten
        chess_kit.board.add_to_cell_state(move_from, :picked)

        en_passant_especial_cases = rules.possible_flanks_for_en_passant(move_from)

        possible_moves_from.each do |coord|
          mark_possible_target_coord(chess_kit, coord, en_passant_especial_cases)
        end
        display_game(chess_kit)
      end

      def self.mark_possible_target_coord(chess_kit, target_coord, en_passant_cases)
        target = chess_kit.board.lookup_cell(target_coord)
        en_passant_coord_exceptions = en_passant_cases.map { |en_passant_case| en_passant_case[:flank] }

        state = if target.content.nil?
                  en_passant_coord_exceptions.include?(target_coord) ? :flankable : :movable
                else
                  :capturable
                end

        chess_kit.board.add_to_cell_state(target_coord, state)
      end
    end
  end
end
