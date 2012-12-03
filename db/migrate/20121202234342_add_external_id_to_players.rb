class AddExternalIdToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :source_id, :integer
    add_column :players, :source, :string
  end
end
