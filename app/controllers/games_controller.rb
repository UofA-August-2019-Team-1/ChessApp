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
      @game = current_user.games.create(:name => game_params[:name], :black_player_id => current_user.id)
      if @game.valid?
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @game = Game.find(params[:id])
    end

    def update
    end

    def join
      @game = Game.find_by_id(params[:id])
      @pieces = @game.pieces
      @pieces.where(user_id:nil).update_all(user_id: current_user.id)

      @game.update_attributes(game_params)
      @game.users << current_user
      redirect_to game_path(@game)
    end

    def destroy
      @game = Game.find_by_id(params[:id])
      @game.pieces.destroy_all
      @games.destroy
      redirect_to games_path
    end

    private

    def game_params
      params.require(:game).permit(:name)
    end

    def games_available
      available_games = []
      Game.where(white_player_id: nil).find_each do |game|
        available_games.push(game)
      end
      return available_games
    end
end
