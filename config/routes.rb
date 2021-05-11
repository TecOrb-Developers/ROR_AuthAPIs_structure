Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	require 'sidekiq/cron/web'
	mount Sidekiq::Web => '/sidekiq'

	namespace :api,defaults: { format: 'json' } do
		namespace :v1 do
			scope :guest do
		        get "identity"=> "guests#create"
		    end

		    scope :sessions do 
		    	post "create" => "sessions#create"
		    	delete "destroy" => "sessions#destroy"
				get "show" => "sessions#show"
		    end
		end
	end

	match "*a" => "application#notFound", via: :all

end
