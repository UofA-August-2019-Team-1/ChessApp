class GamesController < ApplicationController

    # before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

    def index
      @games = Game.all
      # @games = games_available
    end

    def new
      @game = Game.new
    end

    def create
      # @game = Game.new
      @game = Game.create(:name => 'My game')
      redirect_to root_path
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

    def games_available
      available_games = []
      Games.where(black_player_id: null).find_each do |game|
        available_games.push(game)
      end
      return available_games
    end
end
