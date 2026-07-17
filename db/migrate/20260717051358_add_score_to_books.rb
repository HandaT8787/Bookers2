class AddScoreToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :score, :integer
  end
end
