class Hangman
  attr_reader :word, :filename, :wordslist, :attempts_Left, :hidden_word
  attr_writer :guess

  def initialize(filename)
    @wordslist = []
    @filename = filename
  end

  def read_file
    f = File.open(@filename)
    while line = f.gets
      if line.length > 5 and line.length < 12
        # puts line
        @wordslist << line
      end
    end
    f.close
    shuffle_word
  end

  def shuffle_word
    @word = @wordslist.shuffle.first
  end

  def hidden_word
    @word.each_char { |char| print '_ ' }
  end
end

play = Hangman.new('words.txt')
play.read_file
puts play.word
play.hidden_word