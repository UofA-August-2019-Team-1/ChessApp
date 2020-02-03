class PiecesController < ApplicationController
  # before_action :find_piece, :verify_two_players, :verify_player_turn, :verify_valid_move
  before_action :find_piece, :verify_two_players

  def update

    if @piece.selected != true
      #Selecing a piece
      @piece.update_attributes(selected: true)
    else
      #Selecing a destination
      @piece.update_attributes(x_position: params[:x], y_position: params[:y])
      @piece.update_attributes(selected: false)
      switch_turns
    end

    redirect_to game_path(@piece.game)

  #   is_captured
  #   if params[:piece][:type] == "Queen" || params[:piece][:type] == "Bishop" || params[:piece][:type] == "Knight" || params[:piece][:type] == "Rook"
  #     @piece.update_attributes(type: params[:piece][:type])
  #   elsif @piece.type == "King" && @piece.legal_to_castle?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
  #     @piece.castle(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
  #   else
  #     @piece.update_attributes(piece_params.merge(move_number: @piece.move_number + 1))
  #   end
  # end
  #
  #   king_opp = @game.pieces.where(:type =>"King").where.not(:user_id => @game.turn_user_id)[0]
  #   king_current = @game.pieces.where(:type =>"King").where(:user_id => @game.turn_user_id)[0]
  #   game_end = false
  #   if king_opp.check?(king_opp.x_coord, king_opp.y_coord).present?
  #     if king_opp.find_threat_and_determine_checkmate
  #       king_opp.update_winner
  #       king_current.update_loser
  #       game_end = true
  #     else
  #       king_opp.update_attributes(king_check: 1)
  #     end
  #   elsif king_opp.stalemate?
  #     @game.update_attributes(state: "end")
  #     game_end = true
  #   end
  #   if game_end == false && !(@piece.type == "Pawn" && @piece.pawn_promotion?)
  #     update_moves
  #     switch_turns
  #     render json: {}, status: 200
  #   else
  #     render json: {}, status: 201
  #   end
  end

  private

  def verify_two_players
    return if @game.black_player_id && @game.white_player_id
    respond_to do |format|
      format.json {render :json => { message: "Need to wait for second player!", class: "alert alert-warning"}, status: 422}
    end
  end

  def switch_turns
    if @game.white_player_id == @game.turn_user_id
      @game.update_attributes(turn_user_id: @game.black_player_id)
    elsif @game.black_player_id == @game.turn_user_id
      @game.update_attributes(turn_user_id: @game.white_player_id)
    end
  end

  def find_piece
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def verify_valid_move
    return if @piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true) &&
    (@piece.is_obstructed(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (@piece.contains_own_piece?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (king_not_moved_to_check_or_king_not_kept_in_check? == true) ||
    @piece.type == "Pawn" && @piece.pawn_promotion?

    respond_to do |format|
      format.json {render :json => { message: "Invalid move!", class: "alert alert-warning"}, status: 422}
    end
  end

  def verify_player_turn
    return if correct_turn? &&
    ((@piece.game.white_player_id == current_user.id && @piece.color == "white") ||
    (@piece.game.black_player_id == current_user.id && @piece.color == "black"))
    respond_to do |format|
      format.json {render :json => { message: "Not yet your turn!", class: "alert alert-warning"}, status: 422}
    end
  end

  def correct_turn?
    @piece.game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :captured, :white, :id, :type)
  end

  def is_captured
    capture_piece = @piece.find_capture_piece(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
    if !capture_piece.nil?
      @piece.remove_piece(capture_piece)
    end
  end

  def king_not_moved_to_check_or_king_not_kept_in_check?
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.
    king = @game.pieces.where(:type =>"King").where(:user_id => @game.turn_user_id)[0]
    if @piece.type == "King"
      if @piece.check?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true).blank?
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    elsif @piece.type != "King" && king.king_check == 1
      if ([[piece_params[:x_coord].to_i, piece_params[:y_coord].to_i]] & king.check?(king.x_coord, king.y_coord).build_obstruction_array(king.x_coord, king.y_coord)).count == 1 ||
        (@piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true) == true &&
        king.check?(king.x_coord, king.y_coord).x_coord == piece_params[:x_coord].to_i &&
        king.check?(king.x_coord, king.y_coord).y_coord == piece_params[:y_coord].to_i)
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def update_moves
    Move.create(piece_user_id: @piece.user_id, piece_type: @piece.type, x_coord: @piece.x_coord, y_coord: @piece.y_coord, game_id:@game.id)
  end
end
