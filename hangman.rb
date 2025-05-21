require 'json'
require 'pry-byebug'
require 'colorize'

class Hangman
  attr_reader :word, :hidden_word, :attempts, :filename, :guess, :wordslist

  def initialize(filename)
    # declare variables
    @filename = filename
    @word = []
    @wordslist = []
    @hidden_word = []
    @guess = []
    @attempts = 12

    # initialize variables
    read_file
    set_word
    set_hidden_word
  end

  def start_game
    # byebug
    until game_over?
      display_status
      letter = get_guess

      case letter
      when '/save'
        save_game
        break
      when '/load'
        load_game
      end

      check_word_for(letter)
      game_over?
    end
  end

  private

  def read_file
    # Reads a list of words from a file and adds them to a wordlist array.
    f = File.open(@filename)
    while line = f.gets
      line = line.strip # Remove newline and whitespace
      @wordslist << line if line.length > 5 and line.length < 12
    end
  rescue StandardError => e
    puts "Error reading file: #{e.message}"
    @wordslist = []
  end

  def set_hidden_word
    @hidden_word = Array.new(@word.length, '_')
  end

  def set_word
    @word = @wordslist.sample.chars
  end

  def display_status
    puts "word: #{@hidden_word.join(' ')}".colorize(:yellow)
    puts "guessed letters: #{@guess.uniq.join(' ')}".colorize(:red)
    puts "attempts left: #{@attempts}".colorize(:green)
    puts 'Save game with: /save'.colorize(:grey)
    puts 'Load game with /load'.colorize(:grey)
  end

  def get_guess
    puts 'Guess a letter: '
    gets.chomp.downcase
  end

  def check_word_for(letter)
    if @word.include?(letter)
      @word.each_with_index do |item, index|
        @hidden_word[index] = letter if item == letter.strip
      end
    elsif letter == '/load'
      if @guess.include?('/load')
        @guess.delete('/load')
      end
    else
      @attempts -= 1
      @guess << letter
    end

  end

  def game_over?
    if @attempts == 0
      puts 'Game Over'.yellow
      puts "Word: #{@word.join}"
      true
    elsif @word == @hidden_word
      puts 'You Win'.yellow
      true
    end
  end

  def save_game(filename = 'game_save.json')
    game_data = {
      word: @word,
      hidden_word: @hidden_word,
      attemps: @attempts,
      guesses: @guess
    }

    File.open(filename, 'w') do |file|
      file.write(JSON.pretty_generate(game_data))
    end

    puts 'Game saved to game_save'.colorize(:grey)
  end

  def load_game(filename = 'game_save.json')
    if File.exist?(filename)
      data = JSON.parse(File.read(filename), symbolize_names: true)
      @word = data[:word]
      @hidden_word = data[:hidden_word]
      @attempts = data[:attemps]
      @guess = data[:guesses]

      puts 'Game loaded.'.colorize(:grey)
    else
      puts 'No saved game found.'.yellow.on_red
    end
  end
end
