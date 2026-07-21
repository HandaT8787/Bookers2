class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }
      t.text :content, null: false

      t.timestamps
    end

    add_index :messages, [ :sender_id, :recipient_id ]
  end
end
