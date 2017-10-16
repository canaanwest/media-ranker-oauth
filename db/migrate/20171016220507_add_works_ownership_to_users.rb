class AddWorksOwnershipToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :works, :users, foreign_key: true
  end
end
