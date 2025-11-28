class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_decks, dependent: :destroy

  validates :occasion, presence: true, length: { minimum: 2, maximum: 200 }
  validates :target_language, presence: true
end
