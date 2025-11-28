class UserDeck < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :user_cards, dependent: :destroy

  def progress_percent
    learned = user_cards.where(status: true).count
    ((learned.to_f / user_cards.count) * 100).round
  end

  def next_user_card_for(user_deck)
    user_deck.user_cards.find_by(status: false) || user_deck.user_cards.first
  end
end
