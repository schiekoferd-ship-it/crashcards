# app/controllers/user_cards_controller.rb
class UserCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_deck
  before_action :set_user_card, only: [:show, :update]

  # SHOW ACTION - Displays a flashcard (either front or back side)

  def show
    @card = @user_card.card
    @deck = @user_deck.deck   #  ADDED THIS LINE (important for languages)

    # Ordered list of all cards in this user_deck
    @ordered_user_cards = @user_deck.user_cards.order(:id)
    @total_cards        = @ordered_user_cards.count

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
    new_status =
      case params[:answer]
      when "wrong"
        :learning
      when "correct"
        :mastered
      else
        @user_card.status.to_sym
      end

    @user_card.status = new_status

    if @user_card.save
      available_cards = @user_deck.user_cards
                                  .where.not(status: UserCard.statuses[:mastered])
                                  .order(:id)

      next_card = available_cards.where("id > ?", @user_card.id).first
      next_card ||= available_cards.first

      if next_card
        redirect_to user_deck_user_card_path(@user_deck, next_card, side: "front")
      else
        redirect_to user_deck_path(@user_deck),
                    notice: "You mastered all cards in this deck! 🎉"
      end
    else
      redirect_to user_deck_user_card_path(@user_deck, @user_card, side: "front"),
                  alert: "Could not update card"
    end
  end


  private

  def set_user_deck
    @user_deck = current_user.user_decks.find(params[:user_deck_id])
  end

  def set_user_card
    @user_card = @user_deck.user_cards.find(params[:id])
  end
end
