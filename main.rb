require 'pry-byebug'

class Hangman
  attr_reader :word, :filename, :wordslist, :attempts, :hidden_word
  attr_writer :guess, :previous_guesses

  def initialize(filename)
    @wordslist = []
    @hidden_word = []
    @filename = filename
    @attempts = 0
    @guess = []

    read_file
    shuffle_word
  end

  def read_file
    # byebug
    f = File.open(@filename)
    while line = f.gets
      @wordslist << line if line.length > 5 and line.length < 12
    end
    f.close
  end

  def shuffle_word
    @word = @wordslist.sample.chars
  end

  def hidden_word
    # byebug
    @word.each { |_e| @hidden_word << '_' }
    @hidden_word
  end

  def guess_word(letter)
    # check if letter appears in @word
    # if letter appears in word then return index of letter in word
    @word.each_with_index do |item, index|
      if item == letter
        @hidden_word[index] = letter
      end # Closing the if block
    end # Closing the each_with_index block
    @attempts += 1
    @guess << letter
  end

  def word
    puts @word.join
  end

  def test_game
    @word = 'canard'.chars
    guesses = %w[a e o u r d]

    hidden_word
    guesses.each do |letter|
      puts "word: #{@hidden_word.join}"
      puts "guessed letters: #{@guess.join}"
      puts "attempts: #{@attempts}"

      guess_word(letter)
      break if game_over
    end
  end

  def start_game
    hidden_word
    until game_over
      puts "word: #{@hidden_word.join}"
      puts "guessed letters: #{@guess.uniq}"
      puts "attempts: #{@attempts}/#{@word.length}"

      guess_word(guess)
      game_over
    end
  end

  def guess
    puts 'Enter letter: '
    @guess << gets.chomp.downcase
    return @guess.last
  end

  def game_over
    if @hidden_word.eql?(@word)
      puts 'You win!'
      true
    elsif @hidden_word.length == @attempts
      puts 'You lose...'
      puts "Answer: #{@word.join}"
      true
    end
  end

end

play = Hangman.new('words.txt')
# play.test_game
play.start_game
