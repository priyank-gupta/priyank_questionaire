PriyankQuestionaire::Application.routes.draw do

  resources :questions do 
    collection do
      get 'change_answer_div'
      get 'ques_tags'
      get 'make_test'
      get 'fetch_questions', :as => 'fetch'
      get 'show_fetch_ques/:id', :action => 'show_fetch_ques', :as => 'show_fetch_ques'
      match 'tags/:name', :action => 'tags_index', :as => 'tags_index'
      match 'level/:id', :action => 'level_index', :as => 'level_index'
      match 'category/:id', :action => 'category_index', :as => 'category_index'
      match 'download/:test_name', :action => 'download', :as => 'download'
      get 'show_search'
    end
  end
  
  resources :subjective, :except => [:index, :create], :controller => :questions
  resources :multiple_choice, :except => [:index, :create], :controller => :questions
  resources :multiple_choice_answer, :except => [:index, :create], :controller => :questions

  controller :questions do
      get 'subjectives', :action => "index"
      post 'subjectives', :action => "create"
      get 'multiple_choices', :action => "index"
      post 'multiple_choices', :action => "create"
      get 'multiple_choice_answers', :action => "index"
      post 'multiple_choice_answers', :action => "create"
  end
  
#  resources :question, :as => :subjective
#  resources :multiple_choice
#  resources :multiple_choice_answer
  
  devise_for :admins, :controllers => { :omniauth_callbacks => "admins/omniauth_callbacks"}
  
  resources :admins
 
#  match '/questions/tags/:name', :to => "questions#tags_index", :as => 'tag_index'
#  match '/questions/level/:id', :to => "questions#level_index", :as => 'level_index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "questions#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
