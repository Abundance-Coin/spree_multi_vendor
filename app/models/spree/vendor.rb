module Spree
  class Vendor < Spree::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    acts_as_paranoid

    validates :name, presence: true, uniqueness: { case_sensitive: false }

    with_options dependent: :destroy do
      has_many :shipping_methods
      has_many :stock_locations
      has_many :variants
      has_many :products, through: :variants
      has_many :vendor_users
      has_many :price_markups
    end

    has_many :users, through: :vendor_users

    has_attached_file :logo, styles: { thumb: '180x180>', medium: '320x320>' }, default_url: 'vendors/logo.png'
    validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\z}

    after_create :create_stock_location

    state_machine :state, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    self.whitelisted_ransackable_attributes = %w[name state]

    def bank_account
      @bank_account ||= BankAccount.load(gateway_account_profile_id)
    end

    private

    def create_stock_location
      stock_locations.where(name: name, country: Spree::Country.default).first_or_create!
    end
  end
end
