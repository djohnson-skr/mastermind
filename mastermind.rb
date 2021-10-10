# frozen_string_literal: true

require 'colorize'

# create a Mastermind game
class Game
  @@total_turns = 10

  attr_accessor :raw_input, :guess, :number_of_turns, :game_over, :colors
  attr_reader :code, :example_code, :code_maker, :code_breaker

  def play_game
    @number_of_turns = 0
    @game_over = false
    create_numbers
    explain_game
    breaker_or_maker
    create_code
    breaker_game if @code_breaker == true
    maker_game if @code_maker == true
  end

  def breaker_game
    until @game_over
      user_input
      check_code
      is_game_over_breaker
    end
  end

  def maker_game
    until @game_over
      computer_guess
      check_code
      is_game_over_maker
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
    puts ''
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
    puts ''
  end

  def breaker_or_maker
    @code_breaker = false
    @code_maker = false
    puts "To be the code breaker please press '1'"
    puts "To be the code maker please press '2'"
    loop do
      play_option = gets.to_i
      case play_option
      when 1
        @code_breaker = true
        break
      when 2
        @code_maker = true
        break
      else
        puts "Please enter a '1' or '2'"
      end
    end
  end

  def create_code
    if @code_breaker == true
      @code = []
      4.times do
        @code.push(@colors[rand(6)])
      end
    end
    if @code_maker == true
      puts 'Please create your code below:'
      @code = []
      raw_user_code = gets.chomp.split('')
      raw_user_code.map!(&:to_i)
      raw_user_code.each { |n| @code.push(@colors[n - 1]) }
      puts @code.join('')
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
    @guess = []
    @raw_input.each { |n| @guess.push(@colors[n - 1]) }
    puts ''
    print @guess.join
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

  def computer_guess
    @guess = []
    4.times do
      @guess.push(@colors[rand(6)])
    end
    puts ''
    print @guess.join('')
  end

  def check_code
    temp_code = []
    @code.each { |n| temp_code.push(n) }
    print '   '
    temp_guess = []
    @guess.each { |n| temp_guess.push(n) }
    for i in (0..3)
      if temp_guess[i] == temp_code[i]
        print '● '
        temp_code[i] = 0 # clear the '●' number so its not duplicated by include?, '○'
        temp_guess[i] = 9 # ensures the number is not checked for '○' if '●' is true
      end
    end
    for i in (0..3)
      if temp_code.include?(temp_guess[i])
        print '○ '
        clear_num = temp_code.index(temp_guess[i]) # get the index of where @guess[i] in included
        temp_code[clear_num] = 0 # avoid duplicate '○'
      end
    end
    @number_of_turns += 1
  end

  def is_game_over_breaker
    if @guess.eql?(@code)
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

  def is_game_over_maker
    if @guess.eql?(@code)
      puts ''
      puts "\nYou lose! That code was too easy"
      puts ''
      @game_over = true
    elsif @number_of_turns == @@total_turns
      puts ''
      puts "\nYou win! Your code #{@code.join('')} was a doozy!"
      puts ''
      @game_over = true
    end
  end
end

my_game = Game.new
my_game.play_game
