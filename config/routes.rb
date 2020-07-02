Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}

  scope '/loans/:loan_id' do
    resources :payments, defaults: {format: :json}
  end
end
