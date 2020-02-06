class King < Piece
  def valid_move?(new_x_coord, new_y_coord, id = nil, color = nil)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    (x_distance == 1 && y_distance == 0) ||
    (y_distance == 1 && x_distance == 0) ||
    (y_distance == 1 && y_distance == x_distance) 
    legal_to_castle?(new_x_coord, new_y_coord) 
  end
  
  def stalemate?
    return true if !any_moves_left?
    return false
  end

  def legal_to_castle?(new_x_coord, new_y_coord)
    return false unless self.move_number == 0
    return false unless x_distance(new_x_coord) == 2 && y_distance(new_y_coord) == 0
    if new_x_coord > x_coord
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 8).first
    else
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 1).first
    end
    return false if @rook_for_castling.nil?
    if !@rook_for_castling.nil?
      return false unless @rook_for_castling.move_number == 0
      return false if is_obstructed(@rook_for_castling.x_coord, @rook_for_castling.y_coord)
    end
    return true
  end

  def castle(new_x_coord, new_y_coord)
    return false unless legal_to_castle?(new_x_coord, new_y_coord)
    self.update_attributes(x_coord: new_x_coord, y_coord: new_y_coord, move_number: self.move_number + 1)
    if new_x_coord == 3
      @rook_for_castling.update_attributes(x_coord: 4, move_number: 1)
    else new_x_coord == 7
      @rook_for_castling.update_attributes(x_coord: 6, move_number: 1)
    end
  end
end

