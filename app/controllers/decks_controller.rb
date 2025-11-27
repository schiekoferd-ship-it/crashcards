require "json"

class DecksController < ApplicationController
  before_action :set_deck, only: [:edit, :update]

  # OPEN_AI_LANGUAGES = ["🇦🇱 Albanian","🇪🇹 Amharic","🇸🇦 Arabic","🇦🇲 Armenian","🇧🇩 Bengali","🇧🇦 Bosnian","🇧🇬 Bulgarian","🇲🇲 Burmese","🇦🇩 Catalan","🇨🇳 Chinese","🇭🇷 Croatian","🇨🇿 Czech","🇩🇰 Danish","🇳🇱 Dutch","🇪🇪 Estonian","🇫🇮 Finnish","🇫🇷 French","🇬🇪 Georgian","🇩🇪 German","🇬🇷 Greek","🇮🇳 Gujarati","🇮🇳 Hindi","🇭🇺 Hungarian","🇮🇸 Icelandic","🇮🇩 Indonesian","🇮🇹 Italian","🇯🇵 Japanese","🇮🇳 Kannada","🇰🇿 Kazakh","🇰🇷 Korean","🇱🇻 Latvian","🇱🇹 Lithuanian","🇲🇰 Macedonian","🇲🇾 Malay","🇮🇳 Malayalam","🇮🇳 Marathi","🇲🇳 Mongolian","🇳🇴 Norwegian","🇮🇷 Persian","🇵🇱 Polish","🇵🇹 Portuguese","🇮🇳 Punjabi","🇷🇴 Romanian","🇷🇺 Russian","🇷🇸 Serbian","🇸🇰 Slovak","🇸🇮 Slovenian","🇸🇴 Somali","🇪🇸 Spanish","🇰🇪 Swahili","🇸🇪 Swedish","🇵🇭 Tagalog","🇮🇳 Tamil","🇮🇳 Telugu","🇹🇭 Thai","🇹🇷 Turkish","🇺🇦 Ukrainian","🇵🇰 Urdu","🇻🇳 Vietnamese"]
  OPEN_AI_LANGUAGES_SHORT = ["🇬🇧 English", "🇫🇷 French", "🇩🇪 German", "🇮🇹 Italian", "🇪🇸 Spanish", "🇨🇳 Chinese", "🇮🇳 Hindi", "🇧🇩 Bengali", "🇵🇹 Portuguese", "🇷🇺 Russian", "🇯🇵 Japanese", "🇰🇷 Korean"]

  # No authentication here because decks are public.

  def index
    @decks = Deck.all
  end

  def show
    @deck = Deck.find(params[:id])
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
    # here we want to find out the source_language via AI
    @llm_chat = RubyLLM.chat
    instructions = "You are a language detection assistant.
                    Your task is to identify the language of the given input text.
                    Requirements:
                    1. Only return **exactly one element** from this list: #{OPEN_AI_LANGUAGES_SHORT}.
                    2. If the input language is **not in this list**, return exactly: false
                    3. Do not add any explanation, quotes, or extra text. Only return the language or false.
                    Input:"
    @deck.source_language = @llm_chat.with_instructions(instructions).ask(@deck.occasion)

    if @deck.source_language == "false"
      # here needs to be an error message
    else
      until @words_array.is_a?(Array)
        open_ai_call
      end
    end
  end

  def update
    # save deck
    @deck.update(deck_params)
    # create user deck
    @user_deck = UserDeck.create(user: @deck.user, deck: @deck)

    # create user cards
    @deck.cards.each do |card|
      UserCard.create(user_deck: @user_deck, card: card, status: false)
    end

    redirect_to user_decks_path
  end

  private

  def deck_params
    params.require(:deck).permit(:title, :source_language, :target_language, :system_prompt, :occasion)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def open_ai_call(retries = 3)
    set_deck
    system_prompt = "You are an expert in translating practical vocabulary from #{@deck.source_language} to #{@deck.target_language}.
                      Your task is to generate a list of the most important useful words and phrases needed in the following situation: #{@deck.occasion}.
                      Carefully analyze and interpret the situation.
                      Identify vocabulary that is:
                        practical and directly usable in everyday communication
                        relevant for the described situation
                        concise and suitable for flashcards (single words or short phrases)
                        not grammar explanations, not dialogues, not meta-content
                      Do not simply translate the situation itself. Think beyond it and select vocabulary that a person realistically needs to handle the situation.
                      Internally rate each candidate vocabulary item from 1 to 10 for:
                        practicality
                        relevance
                        everyday usability
                      Select only the top 50 items with the highest internal rating.
                      OUTPUT FORMAT (strict):
                        Output an array (length = 50)
                        Each element is a hash with exactly one key-value pair
                        Key: a word or short phrase in #{@deck.source_language} (front side of flashcard)
                        Value: its translation into #{@deck.target_language} (back side of flashcard)
                      Example:
                        [
                        { 'Windel': 'Diaper' },
                        { 'füttern': 'to feed' },
                        { 'schlafen': 'to sleep' }
                        ]
                      Rules:
                        Use **double quotes only**. Never use single quotes.
                        All output must be valid JSON. No comments. No trailing commas.
                        Do not output anything before or after the JSON array.
                        Output only the array, nothing else
                        If both singular and plural exist, include only the singular form unless the plural is more contextually relevant.
                        Numbers must always be written out in full words in both languages (e.g. 625 -> 'six hundred and twenty-five').
                        Do not use digits anywhere in the output.
                        No introductory text, no explanations
                        No formatting like headings or lists outside the array
                        Use plain UTF-8 text
                        Emojis are allowed
                      Follow these instructions exactly."
    @deck.system_prompt = "#{system_prompt}"
    @response = @llm_chat.with_instructions(@deck.system_prompt).ask(@deck.occasion)

    # converting String to Array
    begin
    #Parsing
    @words_array = JSON.parse(@response.content)

    # If parsing complete
    @words_array.each do |element|
      Card.create(front_text: element.keys.first, back_text: element.values.first, deck: @deck)
    end

    # If parsing fails
    rescue JSON::ParserError => e
      if retries > 0
        Rails.logger.error "JSON parse failed, retrying... (#{retries} left)"
        sleep 0.5  # optional
        return open_ai_call(retries - 1)
      else
        raise "AI returned invalid JSON after multiple retries: #{@response.content}"
      end
    end
  end
end
