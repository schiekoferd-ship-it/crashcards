require "json"

class DecksController < ApplicationController
  before_action :set_deck, only: [:edit, :update, :destroy]

  OPEN_AI_LANGUAGES_ISO = ["sq","am","ar","hy","bn","bs","bg","my","ca","zh","hr","cs","da","nl","et","fi","fr","ka","de","el","gu","hi","hu","is","id","it","ja","kn","kz","ko","lv","lt","mk","ms","ml","mr","mn","no","fa","pl","pt","pa","ro","ru","sr","sk","sl","so","es","sw","sv","tl","ta","te","th","tr","uk","ur","vi"]
  OPEN_AI_LANGUAGES_SHORT = ["🇬🇧 English", "🇫🇷 French", "🇩🇪 German", "🇮🇹 Italian", "🇪🇸 Spanish", "🇨🇳 Chinese", "🇮🇳 Hindi", "🇧🇩 Bengali", "🇵🇹 Portuguese", "🇷🇺 Russian", "🇯🇵 Japanese", "🇰🇷 Korean"]
  ISO_MATCHING = {
    "aa"=>"🇪🇷 Afar",
    "ab"=>"🇷🇺 Abkhaz",
    "ae"=>"🌐 Avestan",
    "af"=>"🇿🇦 Afrikaans",
    "ak"=>"🇬🇭 Akan",
    "am"=>"🇪🇹 Amharic",
    "an"=>"🇪🇸 Aragonese",
    "ar"=>"🇸🇦 Arabic",
    "as"=>"🇮🇳 Assamese",
    "av"=>"🇷🇺 Avaric",
    "ay"=>"🇧🇴 Aymara",
    "az"=>"🇦🇿 Azerbaijani",

    "ba"=>"🇷🇺 Bashkir",
    "be"=>"🇧🇾 Belarusian",
    "bg"=>"🇧🇬 Bulgarian",
    "bh"=>"🇮🇳 Bihari",
    "bi"=>"🇻🇺 Bislama",
    "bm"=>"🇲🇱 Bambara",
    "bn"=>"🇧🇩 Bengali",
    "bo"=>"🇨🇳 Tibetan",
    "br"=>"🇫🇷 Breton",
    "bs"=>"🇧🇦 Bosnian",

    "ca"=>"🇦🇩 Catalan",
    "ce"=>"🇷🇺 Chechen",
    "ch"=>"🇬🇺 Chamorro",
    "co"=>"🇫🇷 Corsican",
    "cr"=>"🇨🇦 Cree",
    "cs"=>"🇨🇿 Czech",
    "cu"=>"🌐 Church Slavic",
    "cv"=>"🇷🇺 Chuvash",
    "cy"=>"🇬🇧 Welsh",

    "da"=>"🇩🇰 Danish",
    "de"=>"🇩🇪 German",
    "dv"=>"🇲🇻 Divehi",
    "dz"=>"🇧🇹 Dzongkha",

    "ee"=>"🇬🇭 Ewe",
    "el"=>"🇬🇷 Greek",
    "en"=>"🇺🇸 English",
    "eo"=>"🌐 Esperanto",
    "es"=>"🇪🇸 Spanish",
    "et"=>"🇪🇪 Estonian",
    "eu"=>"🇪🇸 Basque",

    "fa"=>"🇮🇷 Persian",
    "ff"=>"🇸🇳 Fula",
    "fi"=>"🇫🇮 Finnish",
    "fj"=>"🇫🇯 Fijian",
    "fo"=>"🇫🇴 Faroese",
    "fr"=>"🇫🇷 French",
    "fy"=>"🇳🇱 Western Frisian",

    "ga"=>"🇮🇪 Irish",
    "gd"=>"🏴 Scottish Gaelic",
    "gl"=>"🇪🇸 Galician",
    "gn"=>"🇵🇾 Guarani",
    "gu"=>"🇮🇳 Gujarati",
    "gv"=>"🇮🇲 Manx",

    "ha"=>"🇳🇬 Hausa",
    "he"=>"🇮🇱 Hebrew",
    "hi"=>"🇮🇳 Hindi",
    "ho"=>"🇵🇬 Hiri Motu",
    "hr"=>"🇭🇷 Croatian",
    "ht"=>"🇭🇹 Haitian",
    "hu"=>"🇭🇺 Hungarian",
    "hy"=>"🇦🇲 Armenian",
    "hz"=>"🇳🇦 Herero",

    "ia"=>"🌐 Interlingua",
    "id"=>"🇮🇩 Indonesian",
    "ie"=>"🌐 Interlingue",
    "ig"=>"🇳🇬 Igbo",
    "ii"=>"🇨🇳 Sichuan Yi",
    "ik"=>"🇺🇸 Inupiaq",
    "io"=>"🌐 Ido",
    "is"=>"🇮🇸 Icelandic",
    "it"=>"🇮🇹 Italian",
    "iu"=>"🇨🇦 Inuktitut",

    "ja"=>"🇯🇵 Japanese",
    "jv"=>"🇮🇩 Javanese",

    "ka"=>"🇬🇪 Georgian",
    "kg"=>"🇨🇬 Kongo",
    "ki"=>"🇰🇪 Kikuyu",
    "kj"=>"🇦🇴 Kwanyama",
    "kk"=>"🇰🇿 Kazakh",
    "kl"=>"🇬🇱 Greenlandic",
    "km"=>"🇰🇭 Khmer",
    "kn"=>"🇮🇳 Kannada",
    "ko"=>"🇰🇷 Korean",
    "kr"=>"🇳🇬 Kanuri",
    "ks"=>"🇮🇳 Kashmiri",
    "ku"=>"🇹🇷 Kurdish",
    "kv"=>"🇷🇺 Komi",
    "kw"=>"🏴 Cornish",
    "ky"=>"🇰🇬 Kyrgyz",

    "la"=>"🇻🇦 Latin",
    "lb"=>"🇱🇺 Luxembourgish",
    "lg"=>"🇺🇬 Ganda",
    "li"=>"🇳🇱 Limburgish",
    "ln"=>"🇨🇩 Lingala",
    "lo"=>"🇱🇦 Lao",
    "lt"=>"🇱🇹 Lithuanian",
    "lu"=>"🇨🇩 Luba-Katanga",
    "lv"=>"🇱🇻 Latvian",

    "mg"=>"🇲🇬 Malagasy",
    "mh"=>"🇲🇭 Marshallese",
    "mi"=>"🇳🇿 Maori",
    "mk"=>"🇲🇰 Macedonian",
    "ml"=>"🇮🇳 Malayalam",
    "mn"=>"🇲🇳 Mongolian",
    "mr"=>"🇮🇳 Marathi",
    "ms"=>"🇲🇾 Malay",
    "mt"=>"🇲🇹 Maltese",
    "my"=>"🇲🇲 Burmese",

    "na"=>"🇳🇷 Nauru",
    "nb"=>"🇳🇴 Norwegian Bokmål",
    "nd"=>"🇿🇼 North Ndebele",
    "ne"=>"🇳🇵 Nepali",
    "ng"=>"🇳🇦 Ndonga",
    "nl"=>"🇳🇱 Dutch",
    "nn"=>"🇳🇴 Norwegian Nynorsk",
    "no"=>"🇳🇴 Norwegian",
    "nr"=>"🇿🇦 South Ndebele",
    "nv"=>"🇺🇸 Navajo",
    "ny"=>"🇲🇼 Chichewa",

    "oc"=>"🇫🇷 Occitan",
    "oj"=>"🇨🇦 Ojibwe",
    "om"=>"🇪🇹 Oromo",
    "or"=>"🇮🇳 Odia",
    "os"=>"🇷🇺 Ossetian",

    "pa"=>"🇮🇳 Punjabi",
    "pi"=>"🇮🇳 Pali",
    "pl"=>"🇵🇱 Polish",
    "ps"=>"🇦🇫 Pashto",
    "pt"=>"🇵🇹 Portuguese",

    "qu"=>"🇵🇪 Quechua",

    "rm"=>"🇨🇭 Romansh",
    "rn"=>"🇧🇮 Kirundi",
    "ro"=>"🇷🇴 Romanian",
    "ru"=>"🇷🇺 Russian",
    "rw"=>"🇷🇼 Kinyarwanda",

    "sa"=>"🇮🇳 Sanskrit",
    "sc"=>"🇮🇹 Sardinian",
    "sd"=>"🇵🇰 Sindhi",
    "se"=>"🇳🇴 Northern Sami",
    "sg"=>"🇨🇫 Sango",
    "si"=>"🇱🇰 Sinhala",
    "sk"=>"🇸🇰 Slovak",
    "sl"=>"🇸🇮 Slovenian",
    "sm"=>"🇼🇸 Samoan",
    "sn"=>"🇿🇼 Shona",
    "so"=>"🇸🇴 Somali",
    "sq"=>"🇦🇱 Albanian",
    "sr"=>"🇷🇸 Serbian",
    "ss"=>"🇿🇦 Swati",
    "st"=>"🇱🇸 Southern Sotho",
    "su"=>"🇮🇩 Sundanese",
    "sv"=>"🇸🇪 Swedish",
    "sw"=>"🇰🇪 Swahili",

    "ta"=>"🇮🇳 Tamil",
    "te"=>"🇮🇳 Telugu",
    "tg"=>"🇹🇯 Tajik",
    "th"=>"🇹🇭 Thai",
    "ti"=>"🇪🇷 Tigrinya",
    "tk"=>"🇹🇲 Turkmen",
    "tl"=>"🇵🇭 Tagalog",
    "tn"=>"🇧🇼 Tswana",
    "to"=>"🇹🇴 Tongan",
    "tr"=>"🇹🇷 Turkish",
    "ts"=>"🇿🇦 Tsonga",
    "tt"=>"🇷🇺 Tatar",
    "tw"=>"🇬🇭 Twi",
    "ty"=>"🇵🇫 Tahitian",

    "ug"=>"🇨🇳 Uyghur",
    "uk"=>"🇺🇦 Ukrainian",
    "ur"=>"🇵🇰 Urdu",
    "uz"=>"🇺🇿 Uzbek",

    "ve"=>"🇿🇦 Venda",
    "vi"=>"🇻🇳 Vietnamese",
    "vo"=>"🌐 Volapük",

    "wa"=>"🇧🇪 Walloon",
    "wo"=>"🇸🇳 Wolof",

    "xh"=>"🇿🇦 Xhosa",

    "yi"=>"🇮🇱 Yiddish",
    "yo"=>"🇳🇬 Yoruba",

    "za"=>"🇨🇳 Zhuang",
    "zh"=>"🇨🇳 Chinese",
    "zu"=>"🇿🇦 Zulu"
  }

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
    # here we want to find out the source_language via AI
    @llm_chat = RubyLLM.chat
    instructions = "You are a strict language identification classifier.
                    Your task is to identify the language of the input text.
                    You MUST follow these rules exactly:
                    1. You may ONLY return one of the following allowed languages: #{OPEN_AI_LANGUAGES_ISO}
                    2. You should correctly identify the language even if the text contains typos, slang, informal writing, or misspellings, as long as the intended language is clear.
                    3. If the input text does not clearly correspond to ANY of the allowed languages, or if it appears to be fictional, mixed, random, or unidentifiable, you MUST return exactly: false
                    3. Do NOT guess between allowed languages when they are not plausible matches. If you are not confident about which allowed language it is, return false.
                    4. Do NOT provide explanations, probabilities, corrections, or extra text. Output only the language code or false.
                    Input:"

    result = @llm_chat.with_instructions(instructions).ask(@deck.occasion).content
    if result != "false" && ISO_MATCHING.key?(result)
      @deck.source_language = ISO_MATCHING[result]
    else
      @deck.source_language = "false"
    end

    if @deck.source_language == "false"
      @deck.destroy
      redirect_to new_deck_path, alert: "Language could not be detected. Please try again!"
      return
    else
        open_ai_call
    end
    # set title
    set_title
    @deck.save
  end

  def update

    # create user deck
    @user_deck = UserDeck.create(user: @deck.user, deck: @deck)

    # create user cards
    @deck.cards.each do |card|
      UserCard.create(user_deck: @user_deck, card: card, status: false)
    end

    redirect_to user_decks_path
  end

  def destroy
    @deck.destroy
    redirect_to user_decks_path
  end

  private

  def deck_params
    params.require(:deck).permit(:title, :source_language, :target_language, :system_prompt, :occasion, :user)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def open_ai_call(retries = 3)
    example = '[
                { "Windel": "diaper" },
                { "füttern": "to feed" },
                { "schlafen": "to sleep" }
              ]'
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
                        The value must always be a correct and natural translation of the key into #{@deck.target_language}.
                        The key and the value must never be in the same language.
                        Do not copy, repeat, imitate, or slightly modify the key on the value side.
                        The two languages must always be clearly distinguishable.
                      Example:
                        #{example}
                      Rules:
                        Use **double quotes only**. Never use single quotes.
                        All output must be valid JSON. No comments. No trailing commas.
                        Do not output anything before or after the JSON array.
                        Output only the array, nothing else
                        If both singular and plural exist, include only the singular form unless the plural is more contextually relevant.
                        Numbers must always be written out in full words in both languages. For example: if a number contains multiple digits, write the entire number as words only and do not use any digits.
                        When expressing years, always use a two-part decade–decade structure appropriate for the target language (for example: 2025 → twenty twenty-five). Never express years using a >>thousand<< or >>hundred<< construction in any language.
                        Do not use digits anywhere in the output.
                        No introductory text, no explanations
                        No formatting like headings or lists outside the array
                        Use plain UTF-8 text
                        Emojis are not allowed
                      Follow these instructions exactly."
    @deck.system_prompt = system_prompt
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

  def set_title
    llm_chat_title = RubyLLM.chat
    system_prompt = "You generate short, clean titles.
                      TASK:
                      - Summarize the following user input into a title.
                      - The title must be written in #{@deck.source_language}.
                      - Length: 2 to 6 words.
                      OUTPUT RULES (strict):
                      - Output ONLY the title text, nothing else.
                      - No explanations, no quotes, no punctuation around the title.
                      - No emojis.
                      - No markdown or formatting.
                      - Use plain UTF-8 text.
                      Return only the final title."
    response_title = llm_chat_title.with_instructions(system_prompt).ask(@deck.occasion)
    @deck.title = response_title.content
    @deck.save
  end
end
