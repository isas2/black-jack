# frozen_string_literal: true

class Card
  include Validation

  class << self; attr_reader :suits, :ranks end
  @suits = %i[spade heart diamond	club]
  @ranks = %w[A 2 3 4 5 6 7 8 9 10 J Q K]

  def self.back
    0x1F0A0.chr('UTF-8')
  end

  attr_reader :suit, :rank

  validate :suit, :in, Card.suits
  validate :rank, :in, Card.ranks

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
    validate!
  end

  def to_s
    # https://www.alt-codes.net/playing-cards-symbols.php
    suit_char = (65 + Card.suits.index(suit)).chr
    rank_num = 1 + Card.ranks.index(rank) + (%w[Q K].include?(rank) && 1 || 0)
    "0x1F0#{suit_char}#{rank_num.to_s(16).upcase}".to_i(16).chr('UTF-8')
  end
end
