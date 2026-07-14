class CreateViews < ActiveRecord::Migration[8.0]
  def change
    create_table :views do |t|
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
