require 'pry-byebug'

class Hangman
  attr_reader :word, :filename, :wordslist, :attempts, :hidden_word
  attr_writer :guess

  def initialize(filename)
    @wordslist = []
    @hidden_word = []
    @filename = filename
    @attempts = 0

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
  end

  def test_word
    @word = 'canard'.chars
  end

  def word
    puts @word.join
  end

  def start_game(letter)
    hidden_word
    puts @hidden_word.join
    puts "#{@hidden_word.length} Characters"
    # byebug
    letter.each do |item|
      guess_word(item)
      puts @hidden_word.join

      puts "Attemps: #{@attempts}/#{@word.length}"
      win_conditions
    end
  end

  def win_conditions
     if @hidden_word.eql?(@word)
      puts "Winner!"
     elsif @attempts == @hidden_word.length
      puts "game over"
      puts "Word: #{@word.join}"
     end
  end
end

guesses = %w[a e o u r d]
guesses2 = %w[c a n r d]

play = Hangman.new('words.txt')
play.test_word
# play.word
# play.start_game(guesses)
play.start_game(guesses2)