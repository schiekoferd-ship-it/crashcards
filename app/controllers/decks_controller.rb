
class DecksController < ApplicationController
  # OPEN_AI_LANGUAGES = ["🇦🇱 Albanian","🇪🇹 Amharic","🇸🇦 Arabic","🇦🇲 Armenian","🇧🇩 Bengali","🇧🇦 Bosnian","🇧🇬 Bulgarian","🇲🇲 Burmese","🇦🇩 Catalan","🇨🇳 Chinese","🇭🇷 Croatian","🇨🇿 Czech","🇩🇰 Danish","🇳🇱 Dutch","🇪🇪 Estonian","🇫🇮 Finnish","🇫🇷 French","🇬🇪 Georgian","🇩🇪 German","🇬🇷 Greek","🇮🇳 Gujarati","🇮🇳 Hindi","🇭🇺 Hungarian","🇮🇸 Icelandic","🇮🇩 Indonesian","🇮🇹 Italian","🇯🇵 Japanese","🇮🇳 Kannada","🇰🇿 Kazakh","🇰🇷 Korean","🇱🇻 Latvian","🇱🇹 Lithuanian","🇲🇰 Macedonian","🇲🇾 Malay","🇮🇳 Malayalam","🇮🇳 Marathi","🇲🇳 Mongolian","🇳🇴 Norwegian","🇮🇷 Persian","🇵🇱 Polish","🇵🇹 Portuguese","🇮🇳 Punjabi","🇷🇴 Romanian","🇷🇺 Russian","🇷🇸 Serbian","🇸🇰 Slovak","🇸🇮 Slovenian","🇸🇴 Somali","🇪🇸 Spanish","🇰🇪 Swahili","🇸🇪 Swedish","🇵🇭 Tagalog","🇮🇳 Tamil","🇮🇳 Telugu","🇹🇭 Thai","🇹🇷 Turkish","🇺🇦 Ukrainian","🇵🇰 Urdu","🇻🇳 Vietnamese"]
  OPEN_AI_LANGUAGES_SHORT = ["🇬🇧 English", "🇫🇷 French", "🇩🇪 German", "🇮🇹 Italian", "🇪🇸 Spanish", "🇨🇳 Chinese", "🇮🇳 Hindi", "🇧🇩 Bengali", "🇵🇹 Portuguese", "🇷🇺 Russian", "🇯🇵 Japanese", "🇰🇷 Korean"]

  # No authentication here because decks are public.

  def index
    @decks = Deck.order(created_at: :desc)
  end

  def show
    @deck = Deck.find(params[:id])
    @cards = @deck.cards
  end

  def new
    @deck = Deck.new()
  end

  def create
    @deck = Deck.new(deck_params)
    @deck.user = current_user

    if @deck.save
      # creating a new deck just with id, occasion, target language and redirect to edit
      redirect_to edit_deck_path(@deck)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @deck = Deck.find(params[:id])
    # here we want to find out the source_language via AI
    llm_chat = RubyLLM.chat
    instructions = "You are a language detection assistant.
                    Your task is to identify the language of the given input text.
                    Requirements:
                    1. Only return **exactly one element** from this list: #{OPEN_AI_LANGUAGES_SHORT}.
                    2. If the input language is **not in this list**, return exactly: false
                    3. Do not add any explanation, quotes, or extra text. Only return the language or false.
                    Input:"
    @deck.source_language = llm_chat.with_instructions(instructions).ask(@deck.occasion)

    if @deck.source_language == "false"
      # here needs to be an error message
    else
      system_prompt = "You are an expert of translating words and phrases from #{@deck.source_language} to #{@deck.target_language}.
                      Your task is it to understand and interpret this situation described by the user: #{@deck.occasion}
                      Identify the most important practical words and phrases needed for such a situation. Rate your output internally from 1 to 10 regarding the practicality, relevance, everyday usability.
                      Only produce content that can be directly turned into flashcards (e.g. words and example sentences). Do not generate grammar explanations, dialogues or any content that cannot be used as a flashcard.
                      Return only the top 50 words/phrases with the highest rating.
                      Return the results in an array of hashes. Each hash must contain one key-value pair.
                      The key is a verb or phrase in the #{@deck.source_language} (front side of the flashcard).
                      The value is the translation of that verb or phrase into #{@deck.target_language} (back side of the flashcard).
                      Example output format:
                      [
                        { 'Windel': 'Diaper' },
                        { 'füttern': 'to feed' },
                        { 'schlafen': 'to sleep' }
                      ]
                      Use plain text only. Do not use formatting. Use UTF-8 characters. Emojis are allowed. Do not output anything else."
      @deck.system_prompt = "#{system_prompt}"
      @response = llm_chat.with_instructions(@deck.system_prompt).ask(@deck.occasion)
    end
  end

  private

  def deck_params
    params.require(:deck).permit(:title, :source_language, :target_language, :system_prompt, :occasion)
  end
end
