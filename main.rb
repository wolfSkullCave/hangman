class Hangman
  attr_reader :word, :filename, :wordslist, :attempts_Left, :hidden_word
  attr_writer :guess

  def initialize(filename)
    @wordslist = []
    @hidden_word = []
    @filename = filename
  end

  def read_file
    f = File.open(@filename)
    while line = f.gets
      if line.length > 5 and line.length < 12
        @wordslist << line
      end
    end
    f.close
    shuffle_word
  end

  def shuffle_word
    @word = @wordslist.shuffle.first.chars
  end

  def hidden_word
    @word.each {|e| @hidden_word << '_'}
    return @hidden_word
  end

  def guess_word(letter)

  end
end

guesses = ['a', 'e', 'i', 'o', 'u']

play = Hangman.new('words.txt')
play.read_file
print play.word
puts ''
print play.hidden_word
