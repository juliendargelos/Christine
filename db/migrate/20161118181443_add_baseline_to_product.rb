class AddBaselineToProduct < ActiveRecord::Migration
  def change
    add_column :products, :baseline, :string
  end
end
