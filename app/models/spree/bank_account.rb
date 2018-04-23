module Spree
  class BankAccount
    include ActiveModel::Model

    attr_accessor :first_name, :last_name, :city, :line1, :line2, :postal_code, :state,
                  :business_name, :email, :tos_acceptance, :dob, :ssn_last_4,
                  :routing_number, :account_number, :account_holder_name,
                  :account_holder_type

    validates :first_name, :last_name, :city, :line1, :postal_code, :state,
              :business_name, :email, :tos_acceptance, :ssn_last_4,
              :routing_number, :account_number, :account_holder_name,
              :account_holder_type, presence: true

    def self.address_fields
      { city: true, line1: true, line2: false, postal_code: true, state: true }
    end
  end
end
