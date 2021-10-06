# frozen_string_literal: true

require 'colorize'

# create a Mastermind game
class Game
  @@total_turns = 10

  attr_accessor :raw_input, :user_guess, :number_of_turns, :game_over, :colors
  attr_reader :code, :example_code

  def play_game
    @number_of_turns = 0
    @game_over = false
    create_numbers
    explain_game
    code_maker
    until @game_over
      user_input
      check_code
      is_game_over
    end
  end

  def create_numbers
    @one = '1 '.blue
    @two = '2 '.green
    @three = '3 '.white
    @four = '4 '.cyan
    @five = '5 '.red
    @six = '6 '.yellow
    @colors = [@one, @two, @three, @four, @five, @six]
    @example_code = [@three, @five, @two, @two]
  end

  def explain_game
    puts 'Welcome to the game of Mastermind!'
    puts 'The rules of the game are simple.'
    puts " ‣ You have #{@@total_turns} chances to break the code!"
    puts ' ‣ The code consists of 4 numbers each ranging from 1-6'
    puts " ‣ For each color in your guess that is in the correct color and correct
      position in the code sequence, the computer will display a '●' 
      on the right side of the current guess."
    puts " ‣ For each color in your guess that is in the correct color but is NOT 
      in the correct position in the code sequence, the computer will display a '○'
      on the right side of the current guess."
    puts ''
    puts "Example code: #{@example_code.join('')}"
  end

  def code_maker
    @code = []
    4.times do
      @code.push(@colors[rand(6)])
    end
  end

  def user_input
    puts "\n\nPlease enter your guess:"
    @raw_input = ''
    @raw_input = gets.chomp.split('') # creates array of strings
    @raw_input.map!(&:to_i) # convert all items to ints
    until check_user_input
      @raw_input = gets.chomp.split('') # creates array of strings
      @raw_input.map!(&:to_i) # convert all items to ints
    end
    @user_guess = []
    @raw_input.each { |n| @user_guess.push(@colors[n - 1]) }
  end

  def check_user_input
    if @raw_input.length != 4
      puts 'Please enter 4 numbers'
      return false
    end
    @raw_input.each do |n|
      if !n.between?(1,6)
        puts 'Please enter a number 1-6'
        return false
      end
    end
  end

  def check_code
    temp_code = []
    @code.each { |n| temp_code.push(n) }
    puts ''
    print @user_guess.join
    print '   '
    temp_user_guess = []
    @user_guess.each { |n| temp_user_guess.push(n) }
    for i in (0..3)
      if temp_user_guess[i] == temp_code[i]
        print '● '
        temp_code[i] = 0 # clear the '●' number so its not duplicated by include?, '○'
        temp_user_guess[i] = 9 # ensures the number is not checked for '○' if '●' is true
      end
    end
    for i in (0..3)
      if temp_code.include?(temp_user_guess[i])
        print '○ '
        clear_num = temp_code.index(temp_user_guess[i]) # get the index of where @user_guess[i] in included
        temp_code[clear_num] = 0 # avoid duplicate '○'
      end
    end
    @number_of_turns += 1
  end

  def is_game_over
    if @user_guess.eql?(@code)
      puts ''
      puts "\nYou win! Nice job."
      puts ''
      @game_over = true
    elsif @number_of_turns == @@total_turns
      puts ''
      puts "\nYou lose! Pretty tricky code huh?"
      puts "The code is #{@code.join('')}"
      puts ''
      @game_over = true
    end
  end
end

my_game = Game.new
my_game.play_game
