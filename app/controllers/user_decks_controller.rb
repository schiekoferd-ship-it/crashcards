# app/controllers/user_decks_controller.rb
class UserDecksController < ApplicationController
  before_action :authenticate_user!

  # GET /user_decks
  # Shows all decks available to the current user
  def index
    @user_decks = current_user.user_decks.includes(:deck)
  end

  # GET /user_decks/:id
  # Shows details of a specific deck
  def show
    @user_deck = current_user.user_decks.find(params[:id])
    @deck = @user_deck.deck
    @cards = @deck.cards
  end

  # POST /user_decks
  # Assigns a deck to the current user
  def create
    @user_deck = current_user.user_decks.build(user_deck_params)

    if @user_deck.save
      redirect_to user_decks_path, notice: "Deck added successfully!"
    else
      redirect_to decks_path, alert: "Could not add deck"
    end
  end

  # DELETE /user_decks/:id
  # Removes a deck from the user
  def destroy
    @user_deck = current_user.user_decks.find(params[:id])
    @user_deck.destroy
    redirect_to user_decks_path, notice: "Deck removed"
  end

  private

  def user_deck_params
    params.require(:user_deck).permit(:deck_id)
  end
end
