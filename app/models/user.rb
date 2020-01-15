class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable,
        :confirmable, :lockable, :timeoutable,
        :omniauthable, omniauth_providers: [:facebook, :github, :google_oauth2, :twitter]


  has_many :games
  has_many :pieces

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

end

