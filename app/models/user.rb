class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, length: { maximum: 64 }, allow_blank: true

  has_and_belongs_to_many :followings, class_name: "User", join_table: :follows, foreign_key: :follower_id, association_foreign_key: :followed_user_id
  has_and_belongs_to_many :followers, class_name: "User", join_table: :follows, foreign_key: :followed_user_id, association_foreign_key: :follower_id

  has_many :photos
  has_many :albums

  has_and_belongs_to_many :liked_photos, class_name: "Photo", join_table: :photos_users
  has_and_belongs_to_many :liked_albums, class_name: "Album", join_table: :albums_users

  def username
    "#{first_name.downcase}#{last_name.downcase}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
