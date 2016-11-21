class AddDefaultValueOnQuantityInPurchase < ActiveRecord::Migration
  def change
    change_column :purchases, :quantity, :integer, default: 1
  end
end
