class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.integer :x_position
      t.integer :y_position
      t.string :type
      t.integer :user_id
      t.integer :game_id
      t.timestamps
    end
    add_index :pieces, [:user_id, :game_id]
  end
end
