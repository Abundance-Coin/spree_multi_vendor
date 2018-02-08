Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
    get 'vendor_inventory' => 'vendor_inventory#index'
    post 'vendor_inventory' => 'vendor_inventory#upload'
  end

  resources :vendors, only: [:show]
end
