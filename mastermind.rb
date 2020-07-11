# frozen_string_literal: true

# MAIN TESTING EXAMPLE red white blue black

require 'colorize'
require 'pry'

# This class is used to determine the course of the game
class Game
  attr_reader :gamemode
  def initialize
    @chances = 12
    @result = 'win'

    @player = Player.new
    @board = Board.new
  end

  def play
    @board.set_code
    loop do
      puts @board.give_feedback(@player.guess)
      @chances -= 1
      break if @board.win?
      break if lost?

      puts "You have #{@chances} chances remaining."
      print "\n"
    end
    puts "You #{@result}!"
  end

  def lost?
    @result = 'lost' if @chances.zero?
  end

  def encrypt
    @code = @player.ask_for_code
    @possible_colors = %w[red green blue yellow black white]
    @decrypted = Array.new(4) # TUTAJ PA CO WYMYŚLIŁEŚ XDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
    p @computer_guess = %w[red red green green]
    check_input
    @board.usercode(@code)
    decrypt
  end

  def decrypt
    @chances -= 1
    puts @board.give_feedback(@computer_guess)
    analyze_feedback
    decrypt until @chances.zero?
  end

  def random_code
    rnd = []
    4.times { rnd << @possible_colors.sample }
    rnd
  end

  def analyze_feedback
    @possible_colors -= @computer_guess if @board.feedback == []
    
    change_guess
  end

  def change_guess
    @computer_guess = random_code
    @computer_guess = %w[blue blue yellow yellow] if @chances == 11
    @computer_guess = %w[white white black black] if @chances == 10
    p @computer_guess
  end

  def check_input
    until (@code.is_a? Array) &&
          (@code.length == 4) &&
          (all_colors?(@code) == true)
      @code = @player.ask_for_code
    end
  end

  def all_colors?(code)
    code.all? { |peg| %w[red green blue yellow black white].include?(peg) }
  end

  def set_mode
    @gamemode = @player.choose_mode
  end
end

# Class used to determine how the user (player)
# can interact with the program
class Player
  def guess
    puts 'Enter your guess:'
    input = gets.chomp.downcase.split(' ')
    exit(0) if input == ['exit']
    input
  end

  def choose_mode
    puts "Choose game mode by typing \n'guess' if you want to guess the code or\n" \
    "'encrypt' if you want to set the code for the computer to guess"
    input = gets.chomp.downcase

    input
  end

  def ask_for_code
    puts "\nSet the 4 symbols long code for the computer to crack"
    puts 'Choose only from the 6 colors listed above'
    puts "example: red green black green\n\n"
    input = gets.chomp.downcase.split(' ')

    input
  end
end

# board imitates the game board and game elements (such as pegs)
# 4 slots for the colored pegs and up to 4 slots for feedback
class Board
  attr_reader :feedback
  attr_accessor :code
  def initialize
    @possible_colors = %w[red green blue yellow black white]
    @code = []
  end

  def set_code
    4.times { @code << @possible_colors.sample }
    @code
  end

  def usercode(ucd)
    @code = ucd
  end

  def give_feedback(guess)
    @feedback = []

    code_check(guess)
    @feedback.join(' ')
  end

  # Here we're comparing the guess with the code.
  # White peg means correct guess, red peg means
  # the given color is in the code but in a different slot.
  def code_check(guess)
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
        color = 'is_somewhere_else'
        @code_element = 'checked'
      end
    end
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
game.set_mode
if game.gamemode == 'guess'
  game.play
else
  game.encrypt
end
