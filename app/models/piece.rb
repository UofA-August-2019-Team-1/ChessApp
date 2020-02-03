class Piece < ApplicationRecord
  # belongs_to :user
  belongs_to :game

  def move_to(new_x, new_y)
    return false unless valid_move?(new_x, new_y)
      if space_occupied?(new_x, new_y)
      return false

    else
      game.update_attributes(status: 'in_progress')
    end

    capture(new_x, new_y) if occupied?(new_x, new_y)
    update_attributes(x: new_x, y: new_y)
    game.update_attributes(status: "in_check") if checking?
    true
  end

  def opposition_piece?(x_end, y_end, id = nil, color = nil)
    piece = game.pieces.where("x_position = ? AND y_position = ?", x_end, y_end).first
    if id == nil
      if piece.blank?
        return false
      elsif piece.white? != white?
        return true
      elsif piece.white? == white?
        return false
      end
    elsif self.id == id && piece.blank? #empty square
      return false
    elsif self.id == id && piece.white? != white? #the piece is moving into square that has a opposite piece
      return true
    elsif self.id != id && self.white? != color # ex: King moving to square above pawn, and when performing king.check?, pawn will recognize there is an opposition piece, making the vertical move false
      return true
    else
      return false
    end
  end

  def capture(new_x, new_y)
    piece = find_piece(new_x, new_y)
    piece.update_attributes(captured: true, x: nil, y: nil) if piece && color != new.color
  end

  def is_obstructed?(x, y)
    return vertical_obstruction?(x, y) if vertical_move?(x, y)
    return horizontal_obstruction?(x, y) if horizontal_move?(x, y)
    return diagonal_obstruction?(x, y) if diagonal_move?(x, y)
    false
  end

  def vertical_obstruction?(x, y)
    y_min = [y_position, y].min
    y_max = [y_position, y].max
    (y_min + 1...y_max - 1).each do |y_coord|
      return true if place_occupied?(x, y_coord)
    end
    false
  end

  def horizontal_obstruction?(x, y)
    x_min = [x_position, x].min
    x_max = [x_position, x].max
    (x_min + 1...x_max - 1).each do |x_coord|
      return true if place_occupied?(x_coord, y)
    end
    false
  end

  def diagonal_obstruction?(x, y)
    x_direction = x_position < x ? 1 : -1
    y_direction = y_position < y ? 1 : -1

    current_x = x_position + x_direction
    current_y = y_position + y_direction
    while current_x != x && current_y != y
      return true if place_occupied?(current_x, current_y)
      current_x += x_direction
      current_y += y_direction
    end
    false
  end

  def place_occupied?(x, y)
    if game.pieces.where("(x_position = ? AND y_position = ?)", x, y).any?
      return true
    else
      return false
    end
  end

  # determines horizontal distance travelled by piece
  def x_distance(new_x_coord)
    x_distance = (new_x_coord - x_position).abs
  end

  # determines vertical distance travelled by piece
  def y_distance(new_y_coord)
    y_distance = (new_y_coord - y_position).abs
  end

  def diagonal?(x_distance, y_distance)
    x_distance == y_distance
  end

  def white?
    color == 'white'
  end

  def black?
    !white?
  end
end
