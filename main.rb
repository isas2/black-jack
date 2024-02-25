# frozen_string_literal: true

require_relative 'lib/validation'
require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/user_player'
require_relative 'lib/dealer_player'
require_relative 'lib/desktop'
require_relative 'lib/game'

print 'Привет, как тебя зовут?: '
user_name = gets.chomp

game = Game.new(user_name)
game.start
