require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def test_english
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    result = JSON.parse(word_serialized)
    result['found']
  end

  def score
    @word = params[:word]
    @score = 0
    if @word.split('').all? { |letter| params[:letters].split('').include?(letter.upcase) }
      if test_english
        @answer = "Congratulations! <strong>#{@word.upcase}</strong> is a
          valid English word!".html_safe
        @score += @word.size
        session[:score] += @score
      else
        @answer = "<strong>#{@word.upcase}</strong> doesn't seem to be an
          English word!".html_safe
      end
    else
      @answer = "Sorry but <strong>#{@word.upcase}</strong> can't be built out
        of #{params[:letters].split('').join(', ')}.".html_safe
    end
  end

  def res_session
    session[:score] = 0
    redirect_to new_path
  end

end
