class UserDeck < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :user_cards, dependent: :destroy

  # def progress_percent
  #   learned = user_cards.where(status: true).count
  #   ((learned.to_f / user_cards.count) * 100).round
  # end
end
