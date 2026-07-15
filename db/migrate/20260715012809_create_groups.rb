class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :introduction
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
