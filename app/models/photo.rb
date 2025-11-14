class Photo < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :liked_users, class_name: "User", join_table: :photos_users
  has_and_belongs_to_many :albums
end
