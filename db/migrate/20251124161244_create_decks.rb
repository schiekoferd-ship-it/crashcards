class CreateDecks < ActiveRecord::Migration[7.1]
  def change
    create_table :decks do |t|
      t.string :title
      t.string :source_language
      t.string :target_language
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
