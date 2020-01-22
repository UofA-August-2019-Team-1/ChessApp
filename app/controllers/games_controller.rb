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
      @game = Game.create(name: game_params[:name], white_player_id: current_user.id)
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
      redirect_to game_path(@game)
    end

    def destroy
      @game.destroy
    end

    private

    def game_params
      params.require(:game).permit(:name)
    end

    def new_game_setup_ids
      @game.pieces.where(color: 'white').update_all(user_id: @game.white_player_id)
    end
end
