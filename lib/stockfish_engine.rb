require_relative 'chess_kit/coordinate'
class StockfishEngine
  RELATIVE_DIR = '../engine/stockfish/src/stockfish'

  attr_reader :engine

  def initialize
    dir = File.join(__dir__, RELATIVE_DIR)

    @engine = IO.popen(dir, mode: 'r+')
    @all_stdout = []
    @engine.puts('uci')
    ready?
  end

  def prompt_for_move(fen)
    @engine.puts("position fen #{fen}")
    @engine.puts('go movetime 2000')
    loop do
      line = @engine.gets.chomp
      @all_stdout << line
      break if line.start_with?('bestmove')
    end
    engine_answer = @all_stdout.last.split(' ')[1]
    { move_from: Coordinate.from_notation(engine_answer[0, 2]), move_to: Coordinate.from_notation(engine_answer[2, 4]) }
  end

  private

  def ready?
    loop do
      line = @engine.gets.chomp
      @all_stdout << line
      break if line == 'uciok'
    end
  end
end
