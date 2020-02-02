class AddSelectedToPieces < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :selected, :boolean
  end
end
