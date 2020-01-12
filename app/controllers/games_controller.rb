class GamesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

    def index
      @games = Game.all
      puts 'hello'
      puts @games
    end

    def new
      @game = Game.new
    end

    def create
      # @game = Game.new
    end

    def read
      return @game
    end

    def update(game)
      @game = game
    end

    def destroy
      @game.destroy
    end

    def available
      available_games = []
      Games.where(number_of_players: 1).find_each do |game|
        available_games.push(game)
      end
      return available_games
    end
end
