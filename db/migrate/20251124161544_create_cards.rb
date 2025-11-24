class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :front_text
      t.string :back_text
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
