# frozen_string_literal: true

class Deck
  def initialize
    shuffle
  end

  def shuffle
    self.cards = Card.suits.product(Card.ranks).shuffle.map { |c| Card.new(c[0], c[1]) }
  end

  def first
    cards.pop
  end

  def size
    cards.length
  end

  private

  attr_accessor :cards
end
