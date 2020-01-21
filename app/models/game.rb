class Game < ApplicationRecord
  # belongs_to :white_player, class_name: "User"
  # belongs_to :black_player, class_name: "User", optional: true

  has_many :pieces

  def render_pieces_on_board
    Games::RenderPieces.call(self)
  end

end
