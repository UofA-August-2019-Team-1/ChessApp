class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :white_player_id
      t.integer :black_player_id
      t.timestamps
    end
    add_index :games, [:white_player_id, :black_player_id]
  end
end
