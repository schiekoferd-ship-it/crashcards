class DecksController < ApplicationController

  # No authentication her because decks are public.

  def index
    @decks = Deck.all
  end

  def show
    @deck = Deck.find(params[:id])
  end

  def edit
    @deck = Deck.find(params[:id])
  end
end
