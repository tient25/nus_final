class User < ApplicationRecord
  has_and_belongs_to_many :followings, class_name: "User", join_table: :follows, foreign_key: :follower_id, association_foreign_key: :followed_user_id
  has_and_belongs_to_many :followers, class_name: "User", join_table: :follows, foreign_key: :followed_user_id, association_foreign_key: :follower_id

  has_many :photos
  has_many :albums

  has_and_belongs_to_many :liked_photos, class_name: "Photo", join_table: :photos_users
  has_and_belongs_to_many :liked_albums, class_name: "Album", join_table: :albums_users
end
