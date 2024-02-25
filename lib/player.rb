# frozen_string_literal: true

class Player
  include Comparable

  class << self; attr_reader :actions end
  @actions = { pass: 'Пропустить', add: 'Добавить карту', open: 'Открыть карты' }

  attr_reader :name, :cards, :balance, :bet

  def initialize(name)
    @name        = name
    @balance     = 100
    @bet         = 0
    @cards       = []
  end

  def <=>(other)
    real_score <=> other.real_score
  end

  def reset
    self.cards   = []
    @bet         = 0
  end

  def bet=(value)
    raise 'Недостаточно средств на балансе' if balance < value

    @bet = value
    self.balance -= value
  end

  def winnings(value)
    self.balance += value
  end

  def add_card(card)
    cards << card
  end

  def add_cards(*cards)
    self.cards.concat(cards)
  end

  def show_cards
    cards.join(' ')
  end

  def show_cards_back
    ([Card.back] * cards.length).join(' ')
  end

  def real_score
    -score * (score / 22 - 1)
  end

  def score
    score_with_aces_by_one = 0
    aces_counter = 0
    @cards.each do |card|
      if card.rank =~ /\d/
        score_with_aces_by_one += card.rank.to_i
      elsif card.rank == 'A'
        score_with_aces_by_one += 1
        aces_counter += 1
      else
        score_with_aces_by_one += 10
      end
    end
    score_correct(score_with_aces_by_one, aces_counter)
  end

  protected

  attr_writer :balance, :cards

  def score_correct(score, aces)
    while score <= 11 && aces.positive?
      aces -= 1
      score += 10
    end
    score
  end
end
