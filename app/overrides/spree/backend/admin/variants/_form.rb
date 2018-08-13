Deface::Override.new(
  virtual_path: 'spree/admin/variants/_form',
  name: 'Add vendor in variant form',
  insert_bottom: 'div[data-hook="admin_variant_form_additional_fields"]',
  text: <<-HTML
          <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
            <%= f.field_container :vendor_id, class: ['form-group'] do %>
              <%= f.label :vendor_id, 'Vendor' %>
              <%= f.select(:vendor_id, Spree::Vendor.all.collect { |v| [v.name, v.id] }, {}, class: 'form-control') %>
            <% end %>
          <% end %>
        HTML
)
