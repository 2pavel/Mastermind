# frozen_string_literal: true

require 'colorize'
require 'pry'

class Game
  def initialize
    @chances = 12

    @player = Player.new
    @board = Board.new
  end

  def play
    @board.set_code
    loop do
      @guess = @player.guess
      
    end
  end
end

class Player
  def guess
    puts 'Enter your guess (example: "red green red yellow")'
    input = gets.chomp.split(' ')

    input
  end
end

class Board
  attr_reader :code
  def initialize
    @possible_colors = %w[red green blue yellow black white]
    @code = []
  end

  def set_code
    4.times { @code << @possible_colors.sample }
    @code
  end
end

puts "\nTry to guess the secret code of 4 colors! Separate the colors with space only."
puts 'Keep in mind that you have 12 chances and duplicate colors are allowed' \
     "\nPOSSIBLE COLORS: " + 'red '.red + 'green '.green + 'blue '.blue +
     'yellow '.yellow + 'black'.black.on_white + ' ' +
     'white'.white.on_black
puts 'To exit the game type ' + 'exit'.red.on_white
print "\n"

#player = Player.new
#board = Board.new
#board.set_code
game = Game.new
game.play
