class DropWorksId < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :works_id
  end
end
