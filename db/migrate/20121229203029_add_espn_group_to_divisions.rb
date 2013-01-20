class AddEspnGroupToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :espn_group, :integer
  end
end
