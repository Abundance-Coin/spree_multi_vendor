object @vendor
attributes :id, :name, :slug, :customer_support_email

child users: :vendor_members do
  attributes :first_name, :last_name, :email
end
