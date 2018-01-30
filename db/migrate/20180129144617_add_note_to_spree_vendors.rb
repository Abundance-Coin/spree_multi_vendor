class AddNoteToSpreeVendors < SpreeExtension::Migration[5.1]
  def change
    add_column :spree_vendors, :note, :text
  end
end
