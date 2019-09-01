class User < ApplicationRecord
  has_secure_password

  validates :name, :height, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :records

  # mount_uploader :image, ImageUploader
end