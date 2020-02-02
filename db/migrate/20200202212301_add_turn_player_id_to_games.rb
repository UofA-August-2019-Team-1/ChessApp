class AddTurnPlayerIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :turn_user_id, :integer
  end
end
