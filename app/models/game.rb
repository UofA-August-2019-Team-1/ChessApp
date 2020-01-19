class Game < ApplicationRecord
  belongs_to :user

  # belongs_to :white_player, class_name: "User"
  # belongs_to :black_player, class_name: "User", optional: true

  has_many :pieces
  # has_many :user_games
  after_create :set_up_board

  def set_up_board
    # WHITE PIECES
      # Pawns
      (0..7).each do |x|
        Pawn.create(x_position: x, y_position: 6, user_id: white_player_id, game_id: id, color: 'white')
      end

      # Rooks
      [0, 7].each do |x|
        Rook.create(x_position: x, y_position: 7, user_id: white_player_id, game_id: id, color: 'white')
      end

      # Knights
      [1, 6].each do |x|
        Knight.create(x_position: x, y_position: 7, user_id: white_player_id, game_id: id, color: 'white')
      end

      # Bishops
      [2, 5].each do |x|
        Bishop.create(x_position: x, y_position: 7, user_id: white_player_id, game_id: id, color: 'white')
      end

      # Queen
      Queen.create(x_position: 3, y_position: 7, user_id: white_player_id, game_id: id, color: 'white')

      #King
      King.create(x_position: 4, y_position: 7, user_id: white_player_id, game_id: id, color: 'white')
  end
end
