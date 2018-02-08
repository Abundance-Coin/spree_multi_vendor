Deface::Override.new(
  virtual_path: 'spree/products/_cart_form',
  name: 'Add sellers to variants',
  insert_top: '#product-variants ul li',
  text: <<-HTML
          <% if (vendor = variant.vendor).present? %>
            <div>
              <strong>Seller:</strong>
              <%= link_to vendor, target: '_blank' do %>
                <%= vendor.name.humanize %>
              <% end %>
            </div>
          <% end %>
        HTML
)
