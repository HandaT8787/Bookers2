class CreateGroupUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :group_users do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end

    add_index :group_users, [ :user_id, :group_id ], unique: true
  end
end
