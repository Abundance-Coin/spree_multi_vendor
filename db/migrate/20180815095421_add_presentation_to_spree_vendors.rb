class AddPresentationToSpreeVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_vendors, :presentation, :string
  end
end
