class UserCard < ApplicationRecord
  belongs_to :card
  belongs_to :user_deck

  validates :status, inclusion: { in: [true, false] }

end
