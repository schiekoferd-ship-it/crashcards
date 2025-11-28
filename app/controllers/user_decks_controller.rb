class UserDecksController < ApplicationController
  before_action :set_user_deck, only: [:show, :destroy]

  def index
    @user_decks = UserDeck.all
  end

  def show
    @user_deck = UserDeck.find(params[:id])
    @deck = @user_deck.deck # I added this
    @cards = @deck.cards #I added this deck.cards to define @deck

  end

  def create
    @user_deck = UserDeck.new
    @user_deck.user = current_user
    @user_deck.deck = Deck.find(params[:deck_id])
    # create user cards
    @user_deck.deck.cards.each do |card|
      UserCard.create(user_deck: @user_deck, card: card, status: false)
    end

    if @user_deck.save
      redirect_to user_decks_path
    else
      redirect_back fallback_location: decks_path
    end
  end

  def destroy
    @user_deck.destroy
    redirect_to user_decks_path
  end

  private

  def set_user_deck
    #@user_deck = current_user.user_decks.find(params[:id])
    @user_deck = UserDeck.find(params[:id])
  end
end


# test
