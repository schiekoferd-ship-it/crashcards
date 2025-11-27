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
    # user_deck = UserDeck.new(user_deck_params)
    # user_deck.save
  end

  def destroy
    @user_deck.destroy
    redirect_to user_decks_path, notice: "Deck removed"
  end

  private

  def set_user_deck
    #@user_deck = current_user.user_decks.find(params[:id])
    @user_deck = UserDeck.find(params[:id])
  end
end


# test
