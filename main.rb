class Hangman
  attr_accessor :word, :filename

  def initialize(filename)
    @word = []
    @filename = filename
  end

  def read_file
    f = File.open(@filename)
    while line = f.gets
      if line.length > 5 and line.length < 12
        # puts line
        @word << line
      end
    end
    f.close
    shuffle_word
  end

  def shuffle_word
    @word.shuffle.first
  end
end

play = Hangman.new('words.txt')
puts play.read_file
