require 'open-uri'

ALPHABET = [
  %w[A E I L N O R S T U] * 10,
  %w[D G] * 9,
  %w[B C M P] * 8,
  %w[F H V W Y] * 7,
  %w[K] * 6,
  %w[J X] * 3,
  %w[Q Z]
].join.chars

VOWEL = %w[A E I O U].freeze

class GamesController < ApplicationController
  def play
    @data = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{params['word']}").read)
    @grid = generate_grid(10)
    @score = params['score'].to_i || 0
    score if params['word']
  end

  private

  def score
    time_end = Time.now
    total_time = time_end - params['time_start'].to_datetime
    @round_score = word_validation? ? (@data['length'] * 100) / total_time : 0
    @score += @round_score.floor
  end

  def enough_vowels?(grid_array)
    grid_array.any? { |letter| VOWEL.include?(letter) }
  end

  def enought_consonant?(grid_array, grid_size)
    VOWEL.map { |letter| grid_array.count(letter) }.reduce(:+) <= (grid_size / 2)
  end

  def generate_grid(grid_size, grid_array = [])
    until enough_vowels?(grid_array) && enought_consonant?(grid_array, grid_size)
      grid_array = []
      grid_size.times { grid_array << ALPHABET.sample }
    end
    grid_array
  end

  def word_validation?
    if @data['found'] && in_grid?
      @message = 'Good job!'
      true
    else
      @message = 'invalid word :('
      false
    end
  end

  def in_grid?
    grid = params['grid'].split(',')
    params[:word].upcase.chars.all? do |letter|
      grid.count(letter) >= params[:word].upcase.count(letter) && grid.include?(letter)
    end
  end
end
