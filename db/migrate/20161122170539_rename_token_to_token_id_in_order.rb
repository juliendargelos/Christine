class RenameTokenToTokenIdInOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :token, :token_id
  end
end
