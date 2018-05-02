require 'spec_helper'

RSpec.describe Spree::Payment::GatewayOptions, type: :model do
  let(:options) { Spree::Payment::GatewayOptions.new(payment) }

  let(:payment) do
    double(
      Spree::Payment,
      order: order,
      number: 'P1566',
      currency: 'EUR',
      payment_method: payment_method
    )
  end

  let(:payment_method) do
    double(
      Spree::Gateway::Bogus,
      exchange_multiplier: Spree::Gateway::FROM_DOLLAR_TO_CENT_RATE
    )
  end

  let(:order) do
    double(
      Spree::Order,
      email: 'test@email.com',
      user_id: 144,
      last_ip_address: '0.0.0.0',
      number: 'R1444',
      ship_total: '12.44'.to_d,
      additional_tax_total: '1.53'.to_d,
      item_total: '15.11'.to_d,
      promo_total: '2.57'.to_d,
      bill_address: bill_address,
      ship_address: ship_address,
      variants: [variant]
    )
  end

  let(:variant) do
    double Spree::Variant, vendor: vendor
  end

  let(:vendor) { create(:vendor, gateway_account_profile_id: 'stripe_id') }

  let(:bill_address) do
    double Spree::Address, active_merchant_hash: { bill: :address }
  end

  let(:ship_address) do
    double Spree::Address, active_merchant_hash: { ship: :address }
  end

  describe '#account' do
    subject { options.account }

    it { is_expected.to eq 'stripe_id' }
  end

  describe '#to_hash' do
    subject { options.to_hash }

    let(:expected) do
      {
        email: 'test@email.com',
        customer: 'test@email.com',
        customer_id: 144,
        ip: '0.0.0.0',
        order_id: 'R1444-P1566',
        shipping: '1244'.to_d,
        tax: '153'.to_d,
        subtotal: '1511'.to_d,
        discount: '257'.to_d,
        currency: 'EUR',
        billing_address: { bill: :address },
        shipping_address: { ship: :address },
        account: 'stripe_id'
      }
    end

    it { is_expected.to eq expected }
  end
end
