# frozen_string_literal: true

require 'colorize'
require 'pry'

class Game
  def initialize
    @chances = 12
    @result = 'win'

    @player = Player.new
    @board = Board.new
  end

  def play
    @board.set_code
    p @board.code
    loop do
      puts @board.give_feedback(@player.guess)
      @chances -= 1
      break if @board.win?

      if @chances.zero?
        @result = 'lost'
        break
      end
      puts "You have #{@chances} chances remaining."
      print "\n"
    end
    puts "You #{@result}!"
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
        next unless code_element == color

        @feedback << '|'.red
        color = 'is_somewhere'
        @code_element = 'checked'
      end
    end
    @feedback.join(' ')
  end

  def win?
    @feedback.all? { |peg| peg == '|'.white } && @feedback.length == 4
  end
end

puts "\nTry to guess the secret code of 4 colors! Separate the colors with space only."
puts '(example: red green red yellow)'
puts 'Keep in mind that you have 12 chances and duplicate colors are allowed.' \
     "\nPOSSIBLE COLORS: " + 'red '.red + 'green '.green + 'blue '.blue +
     'yellow '.yellow + 'black'.black.on_white + ' ' +
     'white'.white.on_black
puts 'To exit the game type ' + 'exit'.red.on_white
print "\n"

game = Game.new
game.play
