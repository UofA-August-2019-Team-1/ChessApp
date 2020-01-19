class Game < ApplicationRecord
  belongs_to :user

  # belongs_to :white_player, class_name: "User"
  # belongs_to :black_player, class_name: "User", optional: true

  has_many :pieces
  # has_many :user_games

  attr_accessor :board

  # def initialize()
  #   @board = [
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 1, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #     [0, 0, 0, 0, 0, 0, 1, 0],
  #     [0, 0, 0, 0, 0, 0, 0, 0],
  #   ]
  # end

end
