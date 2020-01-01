class GamesController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

    def create
      @game = Game.new()
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


    #game logic??

    def startGame
    end

    def playerMoved
    end 
end
