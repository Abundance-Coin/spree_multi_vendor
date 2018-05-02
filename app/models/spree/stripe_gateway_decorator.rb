module Spree
  module StripeGatewayDecorator
    def options_for_purchase_or_auth(money, creditcard, gateway_options)
      money, creditcard, options = super(money, creditcard, gateway_options)
      options[:destination] = gateway_options[:account]
      return money, creditcard, options
    end
  end
end

Spree::Gateway::StripeGateway.prepend(Spree::StripeGatewayDecorator)