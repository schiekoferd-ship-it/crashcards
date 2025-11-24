class CreateUserCards < ActiveRecord::Migration[7.1]
  def change
    create_table :user_cards do |t|
      t.boolean :status
      t.references :card, null: false, foreign_key: true
      t.references :user_deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
