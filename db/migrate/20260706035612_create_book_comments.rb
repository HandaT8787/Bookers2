class CreateBookComments < ActiveRecord::Migration[8.0]
  def change
    create_table :book_comments do |t|
      t.string :comment
      t.string :text
      t.integer :user_id
      t.integer :book_id

      t.timestamps
    end
  end
end
