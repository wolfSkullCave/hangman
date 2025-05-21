require 'pry-byebug'
require 'json'
require_relative 'hangman'

play = Hangman.new('words.txt')
play.start_game
