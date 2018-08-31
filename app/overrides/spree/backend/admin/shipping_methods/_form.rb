Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'Add vendor select in shipping method form',
  insert_top: 'div[data-hook="admin_shipping_method_form_fields"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <div class='row'>
              <div class='col-xs-12 col-md-6'>
                <%= f.field_container :vendor_id, class: ['form-group'] do %>
                  <%= f.label :vendor_id, Spree.t(:vendor) %>
                  <%= f.collection_select(:vendor_id, Spree::Vendor.all, :id, :name, { }, { class: 'select2' }) %>
                <% end %>
              </div>
            </div>
          <% end %>
        HTML
)
