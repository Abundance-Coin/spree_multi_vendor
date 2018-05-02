Spree::Payment::GatewayOptions.class_eval do
  def account
    order.variants.first&.vendor&.gateway_account_profile_id
  end

  def hash_methods
    [
      :email,
      :customer,
      :customer_id,
      :ip,
      :order_id,
      :shipping,
      :tax,
      :subtotal,
      :discount,
      :currency,
      :billing_address,
      :shipping_address,
      :account
    ]
  end
end
