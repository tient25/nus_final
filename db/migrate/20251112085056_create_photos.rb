class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :is_standalone
      t.boolean :sharing_mode
      t.integer :likes_count
      t.date :publication_date

      t.timestamps
    end
  end
end
