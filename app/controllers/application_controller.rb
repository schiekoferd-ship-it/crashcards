class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # After successful login, send user to decks#index
  def after_sign_in_path_for(resource)
    decks_path
  end
end
