class RemoveUserFromPurchase < ActiveRecord::Migration
  def change
    remove_reference :purchases, :user, index: true, foreign_key: true
  end
end
