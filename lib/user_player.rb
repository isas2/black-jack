# frozen_string_literal: true

require 'io/console'
require 'colorize'

class UserPlayer < Player
  def initialize(name)
    super(name)
    @last_action_index = -1
  end

  def action
    show_actions
    self.last_action_index = select_action - 1
    Player.actions.to_a[last_action_index][0]
  end

  def show_actions
    puts "\n  Ваш ход. Доступные варианты:"
    Player.actions.values.each_with_index do |o, i|
      if i == last_action_index
        puts "  #{i + 1}. #{o} (недоступно)".grey
      else
        puts "  #{i + 1}. #{o}"
      end
    end
  end

  def select_action
    options = ('1'..'3').select.with_index { |_, i| i != last_action_index }
    loop do
      print "\n  Что выбераете? (нажмите #{options.join(' или ')}): "
      char = $stdin.getch
      if options.include?(char)
        puts char
        return char.ord - 48
      end
    end
  end

  def reset
    super
    self.last_action_index = -1
  end

  private

  attr_accessor :last_action_index
end
