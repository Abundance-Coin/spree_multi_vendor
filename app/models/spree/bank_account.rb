require 'stripe'
require 'spree_gateway'

module Spree
  class BankAccount
    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment

    HIDDEN_FIELD = '*********'.freeze

    attr_accessor :first_name, :last_name, :city, :line1, :line2, :postal_code, :state,
                  :business_name, :email, :tos_acceptance, :dob, :ssn, :tax_id,
                  :routing_number, :account_number, :account_holder_name,
                  :account_holder_type, :token, :account_id, :request_ip,
                  :document_file, :stripe_error

    validates :city, :line1, :postal_code, :state, :email, :tos_acceptance, :dob, :token,
              presence: true
    validates :first_name, :last_name, :ssn, :document_file, presence: true, unless: :stripe_legal_verified?

    def self.address_fields
      { city: true, line1: true, line2: false, postal_code: true, state: true }
    end

    def dob=(val)
      @dob = val.is_a?(Hash) ? Time.new(val[1], val[2], val[3]) : val
    end

    def save
      if stripe_account
        update_stripe_account
      else
        create_stripe_account
        load_from_stripe
      end
      self
    end

    def update_stripe_account
      stripe_account.external_account = token if stripe_account_id != token
      stripe_account.legal_entity.address = address_hash
      stripe_account.legal_entity.business_name = business_name
      stripe_account.legal_entity.business_tax_id = tax_id.presence unless tax_id == HIDDEN_FIELD
      unless stripe_legal_verified?
        stripe_account.legal_entity.dob = dob_hash
        stripe_account.legal_entity.first_name = first_name
        stripe_account.legal_entity.last_name = last_name
        stripe_account.legal_entity.type = account_holder_type
        stripe_account.legal_entity.personal_id_number = ssn if ssn.to_i.positive?
        stripe_account.legal_entity.verification.document = upload_document_file if document_file.present?
      end


      @account = stripe_account.save
    end

    def stripe_account_id
      stripe_account.external_accounts.data.first&.id
    end

    def stripe_legal_verified?
      stripe_account&.legal_entity&.verification&.status == 'verified'
    end

    def create_stripe_account
      verification = { document: upload_document_file } if document_file.present?
      @account = create_account(
        country: 'US',
        type: 'custom',
        email: email,
        external_account: token,
        legal_entity: {
          business_name: business_name,
          dob: dob_hash,
          first_name: first_name,
          last_name: last_name,
          personal_id_number: ssn,
          type: account_holder_type,
          address: address_hash,
          verification: verification,
          business_tax_id: tax_id.presence
        },
        tos_acceptance: {
          date: Time.now.to_i,
          ip: request_ip
        }
      )

      self.account_id = @account.id if @account.present?
    end

    def load_from_stripe
      return self if stripe_account.blank?

      self.email = stripe_account.email
      self.business_name = stripe_account.business_name

      load_external_account(stripe_account.external_accounts.data.first)
      load_legal_entity(stripe_account.legal_entity)

      self
    end

    def load_external_account(account)
      return unless account

      self.token = account.id
      self.account_holder_name = account.account_holder_name
      self.account_holder_type = account.account_holder_type
      self.account_number = HIDDEN_FIELD + account.last4
      self.routing_number = account.routing_number
    end

    def load_legal_entity(legal)
      self.city = legal.address.city
      self.line1 = legal.address.line1
      self.line2 = legal.address.line2
      self.state = legal.address.state
      self.postal_code = legal.address.postal_code

      self.dob = Time.new(legal.dob.year, legal.dob.month, legal.dob.day) if legal.dob.year
      self.first_name = legal.first_name
      self.last_name = legal.last_name
      self.ssn = HIDDEN_FIELD if legal.personal_id_number_provided
      self.document_file = legal.verification.document
      self.tax_id = HIDDEN_FIELD if legal.business_tax_id_provided
    end

    def self.load(account_id)
      result = new(account_id: account_id)
      result.load_from_stripe
    end

    private

    def address_hash
      {
        city: city,
        country: 'US',
        line1: line1,
        line2: line2,
        postal_code: postal_code,
        state: state
      }
    end

    def dob_hash
      return if dob.blank?

      {
        day: dob.day,
        month: dob.month,
        year: dob.year
      }
    end

    def stripe_account
      @account ||= retrieve_account(account_id) if account_id.present?
    end

    def retrieve_account(account_id)
      BankAccount.init_stripe
      begin
        Stripe::Account.retrieve(account_id)
      rescue Stripe::PermissionError => exc
        self.stripe_error = exc
        nil
      end
    end

    def create_account(opts)
      BankAccount.init_stripe
      begin
        Stripe::Account.create(opts)
      rescue Stripe::InvalidRequestError => exc
        errors.add(:stripe_error, exc)
        self.stripe_error = exc
        nil
      end
    end

    def upload_document_file
      BankAccount.init_stripe
      begin
        Stripe::FileUpload.create(
          purpose: 'identity_document',
          file: document_file
        )
      rescue Stripe::InvalidRequestError => exc
        errors.add(:document_file, exc.message)
        self.stripe_error = exc
        self.document_file = nil
        nil
      end
    end

    def self.gateway
      @gateway ||= Spree::Gateway::StripeGateway.first
    end

    def self.stripe_key
      gateway&.preferences&.dig(:publishable_key)
    end

    def self.init_stripe
      Stripe.api_key = gateway&.preferences&.dig(:secret_key)
    end
  end
end
