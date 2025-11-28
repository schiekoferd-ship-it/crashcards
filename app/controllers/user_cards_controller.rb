# app/controllers/user_cards_controller.rb
class UserCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_deck, only: [:show, :update]
  before_action :set_user_card, only: [:show, :update]

  # SHOW ACTION - Displays a flashcard (either front or back side)

  def show
    @card = @user_card.card
    @deck = @user_deck.deck   #  ADDED THIS LINE (important for languages)

    # Ordered list of all cards in this user_deck
    @ordered_user_cards = @user_deck.user_cards.order(:id)
    @total_cards        = @ordered_user_cards.count

    # Progress: only count mastered cards (status = true)
    @mastered_cards = @user_deck.user_cards.where(status: true).count
    @progress_percentage = (@mastered_cards.to_f / @total_cards * 100).round

    # Position of current card (for "2/50")
    index = @ordered_user_cards.index(@user_card) || 0
    @current_position = index + 1

    # For Next / Previous navigation
    @previous_user_card = index > 0 ? @ordered_user_cards[index - 1] : nil
    @next_user_card     = index < (@total_cards - 1) ? @ordered_user_cards[index + 1] : nil

    # Decide which side to display
    @side = params[:side] == "back" ? "back" : "front"
  end

  # PATCH /user_decks/:user_deck_id/user_cards/:id
  # Wrong / Correct buttons update status
  def update
    # Card tatus: true = I knew it, false = repeat
    case params[:answer]
    when "wrong"
      @user_card.status = false   # repeat
    when "correct"
      @user_card.status = true    # I knew it
    end

    if @user_card.save
      # only cards set on repeat (status = false)
      available_cards = @user_deck.user_cards
                                  .where(status: false)
                                  .order(:id)

      # next card on repeat/status false
      next_card = available_cards.where("id > ?", @user_card.id).first
      next_card ||= available_cards.first

      if next_card
        redirect_to user_deck_user_card_path(@user_deck, next_card, side: "front")
      else
        # all cards true → back to show view but with param finished=true
        redirect_to user_deck_user_card_path(@user_deck, @user_card, side: "front", finished: true)
      end
    else
      redirect_to user_deck_user_card_path(@user_deck, @user_card, side: "front")
    end
  end

  def reset_all
    @user_deck = current_user.user_decks.find(params[:user_deck_id])

    # reset all cards
    @user_deck.user_cards.update_all(status: false)

    first_card = @user_deck.user_cards.order(:id).first

    redirect_to user_deck_user_card_path(@user_deck, first_card, side: "front")
  end

  private

  def set_user_deck
    @user_deck = current_user.user_decks.find(params[:user_deck_id])
  end

  def set_user_card
    @user_card = @user_deck.user_cards.find(params[:id])
  end

  def find_user_cards_status_false
    set_user_deck
    @user_cards_status_false = []

    @user_deck.user_cards.each do |card|
      if card.status == false
        @user_cards_status_false << card
      end
    end
  end
end
