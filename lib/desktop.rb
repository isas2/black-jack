# frozen_string_literal: true

require 'terminal-table'
require 'io/console'

class Desktop
  def initialize(user, dealer)
    @user = user
    @dealer = dealer
  end

  def show(result = '', open: false)
    cls
    table = Terminal::Table.new do |t|
      t.style = { width: 61, alignment: :center, border: :unicode_thick_edge }
      t.title = "\nИгра \"Black Jack\"\n "
      t.headings = user.name, dealer.name
    end
    add_rows(table, open)
    puts "#{table}\n#{result}"
  end

  def exit?
    loop do
      print "\n  Играем дальше? Да (space) / Нет (esc): "
      c = $stdin.getch
      return false if c == ' '
      return true if c == 27.chr
    end
  end

  def results(rounds)
    cls
    puts "  #{user.name}, спасибо за игру! Всего сыграно #{get_numeric(rounds, %w[раунд раунда раундов])}!"
    if user.balance == dealer.balance
      puts '  Ничья! Все остались при своих.'
    elsif user.balance > dealer.balance
      puts "  Ты победитель! Выигрыш составил #{user.balance - 100} долларов."
    else
      puts "  Твой проигрыш #{100 - user.balance} долларов. Возвращайся когда будут деньги!"
    end
  end

  private

  def add_rows(table, open)
    bet = open ? '' : user.bet
    dealer_cards = open ? dealer.show_cards : dealer.show_cards_back
    dealer_score = open ? wformat('Сумма очков', dealer.score) : ''
    rows = [[wformat('Баланс', user.balance), wformat('Баланс', dealer.balance)]]
    rows << [wformat('Ставка', bet), wformat('Ставка', bet)]
    rows << :separator
    rows << ["\n#{user.show_cards}\n ", "\n#{dealer_cards}\n "]
    rows << [wformat('Сумма очков', user.score), dealer_score]
    table.rows = rows
  end

  def cls
    system('clear') || system('cls')
  end

  def wformat(str1, str2)
    "#{str1}:#{str2.to_s.rjust(26 - str1.length, ' ')}"
  end

  def get_numeric(amount, words)
    return "#{amount} #{words[2]}" if amount.between?(10, 20)

    case amount % 10
    when 1
      "#{amount} #{words[0]}"
    when 2..4
      "#{amount} #{words[1]}"
    when 0, 5..9
      "#{amount} #{words[2]}"
    end
  end

  attr_reader :user, :dealer
end
