class AddNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :introduction, :text
    add_column :users, :profile_image, :string
  end
end
