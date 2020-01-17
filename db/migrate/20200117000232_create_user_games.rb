class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|

      t.timestamps
    end
  end
end
