Spree::Core::Engine.routes.draw do
  namespace :admin, path: Spree.admin_path do
    resources :vendors do
      resources :price_markups do
        collection do
          post :run_recalculate, action: :run_recalculate
        end
      end
    end

    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
    get 'vendor_bank' => 'vendor_bank#edit'
    post 'vendor_bank' => 'vendor_bank#update'

    scope :vendor_inventory do
      get '/', to: 'vendor_inventory#index', as: :vendor_inventory
      match 'upload', to: 'vendor_inventory#upload', via: %i[get post], as: :vendor_inventory_upload
    end
  end

  resources :vendors, only: [:show]
end
