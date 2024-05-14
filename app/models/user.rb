class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :mentors, through: :bookings
  belongs_to :mentor
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
