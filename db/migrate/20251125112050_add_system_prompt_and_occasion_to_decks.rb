class AddSystemPromptAndOccasionToDecks < ActiveRecord::Migration[7.1]
  def change
    add_column :decks, :system_prompt, :string
    add_column :decks, :occasion, :string
  end
end
