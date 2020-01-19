class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :verify_different_user, only:[:join]

    def index
      @games = games_available
    end

    def new
      @game = Game.new
    end

    def create
      @game = current_user.games.create(:name => game_params[:name], :white_player_id => current_user.id)

      set_up_board

      if @game.valid?
        redirect_to game_path(@game)
      else
        render :new, status: :unprocessable_entity
      end

      @game.pieces.create()
    end

    def show
      @game = Game.find(params[:id])
    end

    def update(game)
      @game = game
    end

    def destroy
      @game.destroy
    end

    private

    def game_params
      params.require(:game).permit(:name)
    end

    def games_available
      return Game.where(black_player_id: nil)
    end

    def set_up_board

      @game.pieces.create(:x_position => 0, :y_position => 0, :type => 'rook', :user_id current_user.id, :game_id => game_id)
      @game.pieces.create(:x_position => 1, :y_position => 0, :type => 'knight', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 2, :y_position => 0, :type => 'bishop', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 3, :y_position => 0, :type => 'queen', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 4, :y_position => 0, :type => 'king', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 5, :y_position => 0, :type => 'bishop', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 6, :y_position => 0, :type => 'knight', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 7, :y_position => 0, :type => 'rook', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 0, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 1, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 2, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 3, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 4, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 5, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 6, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)
      # @game.pieces.create(:x_position => 7, :y_position => 1, :type => 'pawn', :user_id current_user.id, :game_id => game_id)

    end
end
