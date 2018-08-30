object false
child(@vendors => :vendors) do
  extends 'spree/api/v1/vendors/show'
end
node(:count) { @vendors.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @vendors.total_pages }
