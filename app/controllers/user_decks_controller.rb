class UserDecksController < ApplicationController
  before_action :set_user_deck, only: [:show, :destroy]

  def index
    @user_decks = UserDeck.all
  end

  def show
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
    @user_deck = UserDeck.find(params[:id])
  end
end
