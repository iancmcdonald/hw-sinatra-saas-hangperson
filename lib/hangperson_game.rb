class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  def initialize(word)
    if word.nil? || word =~ /.*[^A-Za-z].*/
      raise ArgumentError
    end

    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  # @param [String] letter
  def guess(letter)
    if letter.nil? || letter.length != 1 || letter =~ /[^A-Za-z]/
      raise ArgumentError
    end

    letter.downcase!

    if guesses.include?(letter) || wrong_guesses.include?(letter)
      return false
    end

    if word.include? letter
      guesses << letter
    else
      wrong_guesses << letter
    end
    true
  end

  def word_with_guesses
    if guesses.empty?
      word.tr('a-z', '-')
    else
      word.tr('^' + guesses, '-')
    end
  end

  def check_win_or_lose
    if wrong_guesses.length == 7
      :lose
    elsif word_with_guesses == word
      :win
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start {|http|
      return http.post(uri, "").body
    }
  end

end
