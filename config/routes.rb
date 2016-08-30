Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    resources :tags, only: [:index, :create]

    get '/tags/:id',      to: 'tags#index'
    get '/tags/:cat/:id', to: 'tags#show', constraints: TaggableTopicableConstraint
    get '/tags/:cat/:id', to: 'tags#taggable'

    resources :topics, only: [:index, :create]

    get '/topics/:id',      to: 'topics#index'
    get '/topics/:cat/:id', to: 'topics#show', constraints: TaggableTopicableConstraint
    get '/topics/:cat/:id', to: 'topics#topicable'

    get '/info', to: 'info#info'
    root         to: 'info#docs'
  end
end
