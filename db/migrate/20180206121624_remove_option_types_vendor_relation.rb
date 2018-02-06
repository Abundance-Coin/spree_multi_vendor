class RemoveOptionTypesVendorRelation < ActiveRecord::Migration[5.1]
  def change
    remove_column :spree_option_types, :vendor_id
  end
end
