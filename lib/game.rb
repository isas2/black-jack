# frozen_string_literal: true

class Game
  BET_SIZE = 10

  attr_reader :rounds

  def initialize(user_name)
    @deck    = Deck.new
    @dealer  = DealerPlayer.new
    @user    = UserPlayer.new(user_name)
    @desktop = Desktop.new(user, dealer)
    @rounds  = 0
  end

  def start
    loop do
      break if user.balance < BET_SIZE || dealer.balance < BET_SIZE

      new_round
      break if desktop.exit?
    end
    desktop.results(rounds)
  end

  private

  def new_round
    deck.shuffle if deck.size < 17
    start_round
    desktop.show
    user_action = players_step
    desktop.show
    players_step if user_action != :open
    result = stop_round
    desktop.show(result, open: true)
  end

  def players_step
    action = player_action(user)
    player_action(dealer) if action != :open
    action
  end

  def player_action(player)
    action = player.action
    player.add_card(deck.first) if action == :add
    action
  end

  def start_round
    self.rounds += 1
    user.reset
    dealer.reset
    user.add_cards(deck.first, deck.first)
    dealer.add_cards(deck.first, deck.first)
    user.bet = BET_SIZE
    dealer.bet = BET_SIZE
  end

  def stop_round
    if user == dealer
      user.winnings(BET_SIZE)
      dealer.winnings(BET_SIZE)
      "\n  Ничья!"
    else
      winner = [user, dealer].max
      winner.winnings(2 * BET_SIZE)
      "\n  Победил: #{winner.name}"
    end
  end

  attr_accessor :user, :dealer
  attr_writer :rounds
  attr_reader :deck, :desktop
end
