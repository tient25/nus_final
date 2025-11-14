class CreateJoinTablePhotosUsers < ActiveRecord::Migration[8.1]
  def change
    create_join_table :photos, :users do |t|
      # t.index [:photo_id, :user_id]
      # t.index [:user_id, :photo_id]
    end
  end
end
