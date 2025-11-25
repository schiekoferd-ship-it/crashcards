class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_decks, dependent: :destroy
end
