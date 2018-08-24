FactoryBot.define do
  factory :order_with_vendor_items, parent: :order do
    bill_address
    ship_address

    transient do
      line_items_count { 1 }
      line_items_quantity { 1 }
      shipment_cost { 100 }
      shipping_method_filter { Spree::ShippingMethod::DISPLAY_ON_FRONT_END }
      vendor_accounts { false }
      line_item_prices { nil }
      vendor { nil }
    end

    after(:create) do |order, evaluator|
      if evaluator.line_item_prices
        evaluator.line_item_prices.each do |price|
          create(:line_item, order: order,
                             price: price,
                             vendor: evaluator.vendor,
                             quantity: evaluator.line_items_quantity)
        end
      else
        create_list(:line_item,
                    evaluator.line_items_count,
                    order: order,
                    price: evaluator.line_items_price,
                    quantity: evaluator.line_items_quantity,
                    vendor: evaluator.vendor)
      end

      order.line_items.reload

      order.create_proposed_shipments
      order.update_with_updater!

      if evaluator.vendor_accounts
        order.vendors.each do |vendor|
          account = Spree::BankAccount.new(
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            city: FFaker::AddressUS.city,
            line1: FFaker::AddressUS.street_address,
            postal_code: '91110',
            state: FFaker::AddressUS.state_abbr,
            business_name: FFaker::Company.name,
            email: FFaker::Internet.email,
            tos_acceptance: true,
            dob: Time.current - 20.years,
            ssn: FFaker::SSN.ssn,
            routing_number: '110000000',
            account_number: '000123456789',
            account_holder_name: FFaker::Name.name,
            account_holder_type: 'company',
            request_ip: FFaker::Internet.ip_v4_address
          )

          account.save
          vendor.update(gateway_account_profile_id: account.account_id)
        end
      end
    end

    factory :completed_vendor_order do
      state { 'complete' }
      payment_state { 'balance_due' }
      shipment_state { 'pending' }

      after(:create) do |order|
        order.update_column(:completed_at, Time.current)
        order.reload
      end
    end

    factory :vendor_order_ready_to_ship do
      state { 'complete' }
      payment_state { 'paid' }
      shipment_state { 'ready' }

      after(:create) do |order|
        create(:payment, amount: order.total, order: order, state: 'completed')
        order.shipments.each do |shipment|
          shipment.inventory_units.update_all(state: 'on_hand')
          shipment.update_column('state', 'ready')
        end
        order.update_column(:completed_at, Time.current)
        order.reload
      end

      factory :shipped_vendor_order do
        after(:create) do |order|
          order.shipments.each do |shipment|
            shipment.inventory_units.update_all(state: 'shipped')
            shipment.update_column('state', 'shipped')
          end
          order.update_column('shipment_state', 'shipped')
          order.reload
        end
      end
    end
  end
end
