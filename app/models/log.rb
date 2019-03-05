# model para registrar entrada y salida de usuarios
class Log < ApplicationRecord
  # model association
  belongs_to :user
  # validations
  validates_presence_of :timein
end
