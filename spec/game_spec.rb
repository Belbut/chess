# frozen_string_literal: true

require_relative '../lib/game'

require_relative '../lib/chess_kit/board'
require_relative '../lib/chess_kit/pieces'

require_relative './testing_util_spec'

describe Game do
  include TestingUtil
  subject(:game) { described_class.new }
end
