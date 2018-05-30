FactoryBot.define do
  factory :vendor, class: Spree::Vendor do
    name { FFaker::Company.name }
    state :active

    transient do
      stripe_account false
    end

    after(:create) do |vendor, evaluator|
      vendor.shipping_methods << create(:shipping_method, vendor: vendor) if vendor.shipping_methods.empty?

      if evaluator.stripe_account
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
end
