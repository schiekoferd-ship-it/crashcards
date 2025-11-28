# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Deck.destroy_all
Card.destroy_all

# # 1. Childcare example
# deck1 = Deck.create!(
#   title: "Childcare Basics",
#   source_language: "German",
#   target_language: "English"
# )

# Card.create!(deck: deck1, front: "diaper", back: "Windel")
# Card.create!(deck: deck1, front: "story time", back: "Vorlesezeit")
# Card.create!(deck: deck1, front: "snack time", back: "Snack-Pause")

# # 2. Finance meeting example
# deck2 = Deck.create!(
#   title: "Finance & Balance Sheet Vocabulary",
#   source_language: "German",
#   target_language: "English"
# )

# Card.create!(deck: deck2, front: "revenue", back: "Umsatz")
# Card.create!(deck: deck2, front: "gross margin", back: "Bruttomarge")
# Card.create!(deck: deck2, front: "operating expenses", back: "Betriebskosten")
# Card.create!(deck: deck2, front: "cash flow forecast", back: "Cashflow-Prognose")

# # 3. Medical appointment
# deck3 = Deck.create!(
#   title: "Doctor Appointment",
#   source_language: "German",
#   target_language: "English"
# )

# Card.create!(deck: deck3, front: "temperature", back: "Temperatur")
# Card.create!(deck: deck3, front: "stomach ache", back: "Bauchschmerzen")
# Card.create!(deck: deck3, front: "prescription", back: "Rezept")

# # 4. Travel emergencies
# deck4 = Deck.create!(
#   title: "Travel Emergency Phrases",
#   source_language: "German",
#   target_language: "English"
# )

# Card.create!(deck: deck4, front: "lost passport", back: "Pass verloren")
# Card.create!(deck: deck4, front: "police station", back: "Polizeiwache")
# Card.create!(deck: deck4, front: "insurance claim", back: "Versicherungsfall")

# # 5. Restaurant phrases
# deck5 = Deck.create!(
#   title: "Restaurant Survival",
#   source_language: "German",
#   target_language: "English"
# )

# Card.create!(deck: deck5, front: "still water", back: "Wasser ohne Kohlensäure")
# Card.create!(deck: deck5, front: "bill/check", back: "Rechnung")
# Card.create!(deck: deck5, front: "allergies", back: "Allergien")

# Creates a user
puts "Deletes User DB"
User.destroy_all
puts "..."
user = User.create!(email: "bob@gmail.com", password: "wawqat-1jyfrr-peczeX")
puts "Created a user"

# Create Decks
puts "Deletes Deck DB"
Deck.destroy_all
puts "..."
deck1 = Deck.create!(user: user, title: "Childcare Basics", source_language: "🇩🇪 German", target_language: "🇬🇧 English", occasion: "This is the user input text occasion blabla")
deck2 = Deck.create!(user: user, title: "Lawyer Basics", source_language: "🇬🇧 English", target_language: "🇫🇷 French", occasion: "This is the user input text 222 occasion blabla")
puts "Created 2 decks"

# Creates Cards
puts "Deletes Card DB"
Card.destroy_all
puts "..."
card1 = Card.create!(deck: deck1, front_text: "lost passport", back_text: "Pass verloren")
card2 = Card.create!(deck: deck1, front_text: "police station", back_text: "Polizeiwache")
card3 = Card.create!(deck: deck1, front_text: "insurance claim", back_text: "Versicherungsfall")
puts "Created 3 cards for deck1"
card4 = Card.create!(deck: deck2, front_text: "lost passport 222", back_text: "Pass verloren 222")
card5 = Card.create!(deck: deck2, front_text: "police station 222", back_text: "Polizeiwache 222")
card6 = Card.create!(deck: deck2, front_text: "insurance claim 222", back_text: "Versicherungsfall 222")
puts "Created 3 cards for deck2"

# Create User Decks
puts "Deletes User Deck DB"
UserDeck.destroy_all
puts "..."
user_deck1 = UserDeck.create!(user: user, deck: deck1)
user_deck2 = UserDeck.create!(user: user, deck: deck2)
puts "Created 2 user decks"

# Creates User Cards
puts "Deletes User Card DB"
UserCard.destroy_all
puts "..."
UserCard.create!(user_deck: user_deck1, card: card1, status: false)
UserCard.create!(user_deck: user_deck1, card: card2, status: true)
UserCard.create!(user_deck: user_deck1, card: card3, status: false)
puts "Created 3 cards for deck1"
UserCard.create!(user_deck: user_deck2, card: card4, status: true)
UserCard.create!(user_deck: user_deck2, card: card5, status: true)
UserCard.create!(user_deck: user_deck2, card: card6, status: true)
puts "Created 3 cards for deck2"
