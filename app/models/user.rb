class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_one_attached :image
  validates :email, presence: true, uniqueness: true
end
