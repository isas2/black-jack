# frozen_string_literal: true

class DealerPlayer < Player
  def initialize
    super('Дилер')
  end

  def action
    :add if score < 17
  end
end
