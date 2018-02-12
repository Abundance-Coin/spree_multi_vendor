Deface::Override.new(
  virtual_path: 'spree/admin/products/index',
  name: 'Remove sku column from products table',
  remove: '#listing_products thead tr th:first-child, #listing_products tbody tr td:first-child'
)
