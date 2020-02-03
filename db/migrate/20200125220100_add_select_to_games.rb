class AddSelectToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :selected_piece_id, :integer
  end
end
