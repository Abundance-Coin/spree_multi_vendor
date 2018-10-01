class RemoveUnneededVendorsIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :spree_vendor_users, name: 'index_spree_vendor_users_on_vendor_id'
  end
end
