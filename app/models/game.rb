class Game < ApplicationRecord
  attr_accessor :available_squares
  attr_accessor :selected_piece

  # belongs_to :user
  # belongs_to :white_player, class_name: "User"
  # belongs_to :black_player, class_name: "User", optional: true

  has_many :pieces
  # has_many :user_games

  after_create :render_pieces_on_board

  def render_pieces_on_board
    add_white_pieces
    add_black_pieces
  end

  def add_white_pieces
    add_piece_row(7, 'white')
    add_pawns(6, 'white')
  end

  def add_black_pieces
    add_piece_row(0, 'black')
    add_pawns(1, 'black')
  end

  def add_piece_row(row, color)
    add_rook(row, 0, color)
    add_rook(row, 7, color)

    add_knight(row, 1, color)
    add_knight(row, 6, color)

    add_bishop(row, 2, color)
    add_bishop(row, 5, color)

    add_queen(row, 3, color)
    add_king(row, 4, color)
  end

  def add_pawns(row, color)
    8.times do |col|
      add_pawn(row, col, color)
    end
  end

  def add_rook(row, col, color)
    Rook.create(x_position: col, y_position: row, game_id: id, color: color)
  end

  def add_knight(row, col, color)
    Knight.create(x_position: col, y_position: row, game_id: id, color: color)
  end

  def add_bishop(row, col, color)
    Bishop.create(x_position: col, y_position: row, game_id: id, color: color)
  end

  def add_queen(row, col, color)
    Queen.create(x_position: col, y_position: row, game_id: id, color: color)
  end

  def add_king(row, col, color)
    King.create(x_position: col, y_position: row, game_id: id, color: color)
  end

  def add_pawn(row, col, color)
    # Pawn.create(x_position: col, y_position: row, game_id: id, color: color)
    Pawn.create(x_position: col, y_position: row, game_id: id, color: color)
  end
 
  
  def check?(color)
    black_king = game.pieces.find_by(color: "black", type: "King")
    white_king = game.pieces.find_by(color: "white", type: "King")
    
    black_piece = game.pieces.where(color: "black")
    white_piece = game.pieces.where(color: "white")

    if color == "white"
      white_piece.each do |piece|
        if white_piece.pawns.valid_move?(black_king.x_place, black_king.y_place)||
          white_piece.queens.valid_move?(black_king.x_place, black_king.y_place) ||
          white_piece.rooks.valid_move?(black_king.x_place, black_king.y_place) ||
          white_piece.knights.valid_move?(black_king.x_place, black_king.y_place) ||
          white_piece.bishops.valid_move?(black_king.x_place, black_king.y_place) ||
          white_piece.kings.valid_move?(black_king.x_place, black_king.y_place)
          return true
        else
          return false
        end
      end
    end

    if color == "black"
      black_piece.each do |piece|
        if black_piece.pawns.valid_move?(white_king.x_place, white_king.y_place)||
          black_piece.queens.valid_move?(white_king.x_place, white_king.y_place) ||
          black_piece.rooks.valid_move?(white_king.x_place, white_king.y_place) ||
          black_piece.knights.valid_move?(white_king.x_place, white_king.y_place) ||
          black_piece.bishops.valid_move?(white_king.x_place, white_king.y_place) ||
          black_piece.kings.valid_move?(white_king.x_place, white_king.y_place)
          return true
        else
          return false
        end
      end
    end
  end


end
