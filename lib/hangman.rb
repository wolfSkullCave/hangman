require 'json'
require 'pry-byebug'
require 'colorize'

class Hangman
  attr_reader :word, :hidden_word, :attempts, :filename, :guess, :wordslist, :save_path

  def initialize(filename)
    # declare variables
    @filename = filename
    @word = []
    @wordslist = []
    @hidden_word = []
    @guess = []
    @attempts = 12
    @save_path = File.join(File.dirname(__FILE__), '../save_files/game_save.json')

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
        next
      end

      process_guess(letter)
    end
  end

  def process_guess(letter)
    return if letter.empty? || @guess.include?(letter)
    if @word.include?(letter)
      @word.each_with_index do |item, index|
        @hidden_word[index] = letter if item == letter
      end
    else
      @attempts -= 1
    end
    @guess << letter
  end

  private

  def read_file
    # Reads a list of words from the correct file location
    words_path = File.join(File.dirname(__FILE__), 'words.txt')
    f = File.open(words_path)
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

  def save_game(filename = nil)
    filename ||= @save_path
    game_data = {
      word: @word,
      hidden_word: @hidden_word,
      attemps: @attempts,
      guesses: @guess
    }

    File.open(filename, 'w') do |file|
      file.write(JSON.pretty_generate(game_data))
    end

    puts "Game saved to #{filename}".colorize(:grey)
  end

  def load_game(filename = nil)
    filename ||= @save_path
    if File.exist?(filename)
      data = JSON.parse(File.read(filename), symbolize_names: true)
      @word = data[:word]
      @hidden_word = data[:hidden_word]
      @attempts = data[:attemps]
      @guess = data[:guesses]

      puts 'Game loaded.'.colorize(:grey)

      # delete save file after load
      File.delete(filename) if File.exist?(filename)
    else
      puts 'No saved game found.'.yellow.on_red
    end
  end
end
