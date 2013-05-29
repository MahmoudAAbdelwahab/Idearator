Sprint0::Application.routes.draw do

  default_url_options :host => 'localhost:3000'
  root :to => 'stream#index'

  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks',
                                       :registrations => 'registrations' }

  devise_scope :user do
    match 'users/registrations/twitter_screen_name_clash' => 'registrations#twitter_screen_name_clash'
  end

  resources :competitions

  resources :users do
    member do
      match 'ban_unban' => 'admins#ban_unban'
      match 'ideas'
      match 'approve_committee' => 'users#approve_committee'
      match 'reject_committee' => 'users#reject_committee'
      match 'invite_member' => 'users#invite_member'
    end

    collection do
      put 'change_settings'
      match 'expertise'
      match 'new_committee_tag'
      match 'confirm_deactivate'
      match 'deactivate'
      match 'profile_modal'
      match 'send_expertise'
    end
  end

  resources :ideas do
    match 'filter', on: :collection
    match 'like', on: :member
    resources :comments do
      put 'update', on: :member
    end
    member do
      match 'vote'
      match 'unvote'
      match 'archive'
      match 'unarchive', :defaults => { :format => 'js' }
      match 'add_prespectives' => 'committees#add_prespectives'
      match 'disapprove' => 'committees#disapprove'
      match 'add_rating'
      match 'popover'
    end
  end

  resources :user_ratings, :controller => 'user_ratings'
  match '/user_ratings/create' => 'user_ratings#create'
  match '/user_ratings/update' => 'user_ratings#update'


  # Admin actions routes
  controller :admins do
    match 'admins/invite'
    match 'invite_committee'
  end

  # Committe actions routes
  controller :committees do
    match 'review_ideas'
  end

  # Dashboard routes
  controller :dashboard do
    match 'dashboard/index'
    match 'getallideas'
    match 'gettags'
    match 'getideas'
    match 'dashboard/chart_data/:tag_id'=>'dashboard#chart_data'
  end

  # Notifications routes
  controller :notifications do
    match 'view_all_notifications'
    match 'redirect_idea'
    match 'redirect_review'
    match 'redirect_expertise'
    match 'set_read'
    match 'redirect_stream'
    match 'redirect_competition'
    match 'view_new_notifications'
  end
  match 'notifications' => 'application#update_nav_bar'

  # Tag routes
  controller :tags do
    match 'tags/ajax'
  end

  controller :ratings do
    match 'ratings/ajax'
  end


  controller :competitions do
    resources :competitions do
      member do
        match 'review_competitions_ideas' => 'competitions#review_competitions_ideas'
        match 'approve' => 'competitions#approve'
        match 'reject' => 'competitions#reject'
      end
    end
    match 'notification_review' => 'competitions#notification_review'
  end

  resources :competitions

  match 'competitions/:id/enroll_idea/:idea_id' => 'competitions#enroll_idea'
  match 'ideas/:id/enter_competition/:competition_id' => 'ideas#enter_competition'

controller :stream do
    match '/stream/index'
  end

  controller :coolster do
    match 'coolster/add_online_user'
    match 'coolster/remove_online_user'
  end

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended
  # for RESTful applications.
  # Note: This route will make all actions in every controller
  # accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/review_ideas' => 'committees#review_ideas'
  match '/users/confirm_deactivate' => 'users#confirm_deactivate'
  match '/users/deactivate' => 'users#deactivate'


  #2.3 Create/Edit Tags
  resources :tags

  match 'tags/:id/synonym' => 'tags#addsym', :via => :put
  match 'tags/:id/delsym' => 'tags#delsym', :via => :put

end

