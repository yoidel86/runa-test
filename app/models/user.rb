# defining User Model
class User < ApplicationRecord
  has_secure_password
  # model association
  has_many :logs, dependent: :destroy
  # validations
  validates_presence_of :name
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
