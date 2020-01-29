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
    y_min = [y_place, y].min
    y_max = [y_place, y].max
    (y_min + 1...y_max - 1).each do |y_coord|
      return true if place_occupied?(x, y_coord)
    end
    false
  end

  def horizontal_obstruction?(x, y)
    x_min = [x_place, x].min
    x_max = [x_place, x].max
    (x_min + 1...x_max - 1).each do |x_place|
      return true if place_occupied?(x_place, y)
    end
    false
  end

  def diagonal_obstruction?(x, y)
    x_direction = x_place < x ? 1 : -1
    y_direction = y_place < y ? 1 : -1

    current_x = x_place + x_direction
    current_y = y_place + y_direction
    while current_x != x && current_y != y
      return true if place_occupied?(current_x, current_y)
      current_x += x_direction
      current_y += y_direction
    end
    false
  end
end
