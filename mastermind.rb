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
    p @board.code
    loop do
      @guess = @player.guess
      print @board.give_feedback(@guess)
      print "\n"
      @chances -= 1
      break if @board.feedback.all? { |peg| peg == '|'.white } && @board.feedback.length == 4
    end
    puts 'You win!'
  end
end

class Player
  def guess
    puts 'Enter your guess:'
    input = gets.chomp.split(' ')

    input
  end
end

class Board
  attr_reader :code, :feedback
  def initialize
    @possible_colors = %w[red green blue yellow black white]
    @code = []
  end

  def set_code
    4.times { @code << @possible_colors.sample }
    @code
  end

  def give_feedback(guess)
    @feedback = []
    @not_guessed = []
    @code_scan = []

    4.times do |i|
      if guess[i] == @code[i]
        @feedback << '|'.white
        @code_scan[i] = nil
      else
        @not_guessed << guess[i]
        @code_scan[i] = @code[i]
      end
    end
    @not_guessed.each do |color|
      @code_scan.each do |code_element|
        if code_element == color
          @feedback << '|'.red
          color = 'is_somewhere'
          @code_element = 'checked'
        end
      end
    end
    @feedback.join(' ')
  end
end

puts "\nTry to guess the secret code of 4 colors! Separate the colors with space only."
puts '(example: red green red yellow)'
puts 'Keep in mind that you have 12 chances and duplicate colors are allowed' \
     "\nPOSSIBLE COLORS: " + 'red '.red + 'green '.green + 'blue '.blue +
     'yellow '.yellow + 'black'.black.on_white + ' ' +
     'white'.white.on_black
puts 'To exit the game type ' + 'exit'.red.on_white
print "\n"

game = Game.new
game.play
