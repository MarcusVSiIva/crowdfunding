# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  include DeviseTokenAuth::Concerns::User

  scope :active, -> { where(active: true) }

  has_many :sponsorships

  validates :email, presence: true
end
