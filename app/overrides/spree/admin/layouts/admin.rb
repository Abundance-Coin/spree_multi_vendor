Deface::Override.new(
  virtual_path:  'spree/layouts/admin',
  name:          'vendors_main_menu_tabs',
  insert_bottom: '#main-sidebar',
  text:       <<-HTML
                <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
                  <ul class="nav nav-sidebar">
                    <%= tab plural_resource_name(Spree::Vendor), url: admin_vendors_path, icon: 'money' %>
                  </ul>
                <% end %>
                <% if current_spree_vendor %>
                  <ul class="nav nav-sidebar">
                    <%= main_menu_tree Spree::Vendor.model_name.human, icon: 'money', sub_menu: 'vendors', url: '#sidebar-vendors' %>
                  </ul>
                <% end %>
              HTML
)
