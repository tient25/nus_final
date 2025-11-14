class AddImageToPhotos < ActiveRecord::Migration[8.1]
  def change
    add_column :photos, :image, :string
  end
end
