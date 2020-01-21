class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :verify_different_user, only:[:join]

    def index
      @games_available = Game.where(:white_player_id => nil).where.not(:black_player_id => nil).or (Game.where.not(:white_player_id => nil).where(:black_player_id => nil))
    end

    def new
      @game = Game.new
    end

    def create
      @game = current_user.games.create(:name => game_params[:name], :white_player_id => current_user.id)

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
      @piece = Piece.find(params[:id])
      redirect_to game_path(@game)
    end

    def destroy
      @game.destroy
    end

    private

    def game_params
      params.require(:game).permit(:name)
    end
end
