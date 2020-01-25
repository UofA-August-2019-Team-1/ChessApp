class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :verify_different_user, only:[:join]

    def index

      if current_user
        @games_available = Game.where.not(:black_player_id => current_user.id).or (Game.where.not(:white_player_id => current_user.id))
        @games_active = Game.where(:black_player_id => current_user.id).or(Game.where(:white_player_id => current_user.id))
      end
    end

    def new
      @game = Game.new
    end

    def create
      @game = Game.create(name: game_params[:name], black_player_id: current_user.id)
      new_game_setup_ids

      if @game.valid?
        redirect_to game_path(@game)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @game = Game.find(params[:id])
      @pieces = @game.pieces
    end

    def update
      @game = Game.find(params[:id])
      @game.update_attributes(white_player_id: current_user.id)
      join_game_setup_ids
      redirect_to game_path(@game)
    end

    def destroy
      @game = Game.find_by_id(params[:id])
      @game.pieces.destroy_all
      @game.destroy
      redirect_to games_path
    end


    private

    def game_params
      params.require(:game).permit(:name)
    end

    def new_game_setup_ids
      @game.pieces.where(color: 'black').update_all(user_id: @game.black_player_id)
    end

    def join_game_setup_ids
      @game.pieces.where(color: 'white').update_all(user_id: @game.white_player_id)
    end
end
