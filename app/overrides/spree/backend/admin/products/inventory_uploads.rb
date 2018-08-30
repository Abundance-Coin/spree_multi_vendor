Deface::Override.new(
  virtual_path: 'spree/admin/products/inventory_uploads',
  name: 'Add vendor to product uploads table head',
  insert_bottom: 'tr[data-hook="admin_product_uploads_headers"]',
  text:       <<-HTML
                <th>Vendor</th>
              HTML
)

Deface::Override.new(
  virtual_path: 'spree/admin/products/inventory_uploads',
  name: 'Add vendor to product uploads table body',
  insert_bottom: 'tr[data-hook="admin_product_uploads_rows"]',
  text:       <<-HTML
                <td>
                  <%= upload.vendor.name %>
                </td>
              HTML
)
