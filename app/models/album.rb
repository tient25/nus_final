class Album < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :liked_users, class_name: "User", join_table: :albums_users
  has_and_belongs_to_many :photos
end
