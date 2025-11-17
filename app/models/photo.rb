class Photo < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :liked_users, class_name: "User", join_table: :photos_users
  has_and_belongs_to_many :albums

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :image, presence: true
  validates :sharing_mode, inclusion: { in: [ true, false ] }

  before_save :set_publication_date

  private

  def set_publication_date
    self.publication_date ||= Date.current
  end
end
