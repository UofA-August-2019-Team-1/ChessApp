class Game < ApplicationRecord
  belongs_to :user

  # belongs_to :white_player, class_name: "User"
  # belongs_to :black_player, class_name: "User", optional: true

  has_many :pieces
  has_many :user_games
  has_many :pieces

end
