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
user = User.create!(email: "bob@gmail.com", password: "Password123")
puts "Created a user"
