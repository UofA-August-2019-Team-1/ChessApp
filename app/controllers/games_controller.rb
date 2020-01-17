class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :verify_different_user, only:[:join]

    def index
      @games = Game.all
      # @games = games_available
    end

    def new
      @game = Game.new
    end

    def create
      @game = current_user.games.create(game_params)
      if @game.valid?
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
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
      available_games = []
      Games.where(black_player_id: null).find_each do |game|
        available_games.push(game)
      end
      return available_games
    end
end
