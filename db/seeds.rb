# db/seeds.rb

puts "🗑️  Limpiando base de datos..."
UserCard.destroy_all
Card.destroy_all
UserDeck.destroy_all
Deck.destroy_all
User.destroy_all
puts "✅ Base de datos limpia!"

# 1. CREAR USUARIO
puts "\n👤 Creando usuario..."
user = User.create!(
  email: "test@test.com",
  password: "123456",
  password_confirmation: "123456",
  name: "Test User"
)
puts "✓ Usuario creado: #{user.email}"

# 2. CREAR MAZO
puts "\n📦 Creando mazo..."
deck = Deck.create!(
  title: "German Basics",
)
puts "✓ Mazo creado: #{deck.title}"

# 3. CREAR TARJETAS
puts "\n🎴 Creando tarjetas..."
card1 = Card.create!(deck: deck, front_text: "Hund", back_text: "Dog")
card2 = Card.create!(deck: deck, front_text: "Katze", back_text: "Cat")
card3 = Card.create!(deck: deck, front_text: "Haus", back_text: "House")
puts "✓ 3 tarjetas creadas"

# 4. CONECTAR USUARIO CON MAZO (⭐ CLAVE)
puts "\n🔗 Conectando usuario con mazo..."
user_deck = UserDeck.create!(
  user: user,
  deck: deck
)
puts "✓ UserDeck creado: ID #{user_deck.id}"

# 5. CREAR PROGRESO (UserCards)
puts "\n📊 Creando progreso de tarjetas..."
UserCard.create!(card: card1, user_deck: user_deck, status: false)
UserCard.create!(card: card2, user_deck: user_deck, status: false)
UserCard.create!(card: card3, user_deck: user_deck, status: false)
puts "✓ Progreso creado para 3 tarjetas"

puts "\n" + "="*50
puts "🎉 SEED COMPLETADO!"
puts "="*50
puts "Usuarios: #{User.count}"
puts "Mazos: #{Deck.count}"
puts "Tarjetas: #{Card.count}"
puts "UserDecks: #{UserDeck.count}"
puts "UserCards: #{UserCard.count}"
puts "\n🔑 Login: test@test.com / 123456"
puts "="*50
