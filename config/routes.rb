Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :tags, only: [:index, :create]

    get '/tags/:id',      to: 'tags#index'
    get '/tags/:cat/:id', to: 'tags#show',     constraints: TaggableConstraint
    get '/tags/:cat/:id', to: 'tags#taggable'
    root                  to: 'tags#docs'
  end
end
