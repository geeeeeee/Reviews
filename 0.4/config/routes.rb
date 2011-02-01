Obri::Application.routes.draw do 
  #devise_for :users
  devise_for :users do
  	match 'user' => "papers#index", :as => :user_root
#, :constraints => { :domain => 'example.com'}
  end
  # 이거 아래에는 crud 등 기본적인 것이 매치됨.
  resources :users

  get "home/index"

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

  resource :instructions do
    collection do
      get "index"
      get 'authorship'
      get "instruction_for_online_submission"
      get "instruction_for_author"
      get "rules_of_edit"
      get "procedure"
    end
  end
  
  # collection 은 일반 함수. member 는 id 각각에 적용. controller/func 와 controller/func/id 의 차이.
  resources :papers do
    collection do
      get 'all_paper'
      get 'review'
      get "filtered_for_editor"
      get 'authorship'
      get 'completed_paper'
    end
    member do
      get "make_comment"
      get 'confirm_submission'
      get "change_status"
      get 'result'
    end
  end
  
  resources :roles do
    collection do
      get "modify_role"
      get "all_user"
      get "manage_role"
      get "assignment"
    end
    member do
      get "change_role"
      get "make_assignment"
    end
  end

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
  root :to => "home#index"
  

  # 로그인 후 리다이렉트 view에 위치.
  # name 스페이스에 대한것을 일거봐야 할듯. 두군데 써주었음.
  namespace :user do
    root :to => "home#index"
    resources :papers
    resources :papers do
      collection do
        get 'all_paper'
        get 'authorship'
        get 'review'
        get "filtered_for_editor"
        get 'completed_paper'
      end
      member do
        get "make_comment"
        get 'confirm_submission'
        get "change_status"
        get 'result'
      end
    end
    
    resources :roles do
      collection do
        get "modify_role"
        get "all_user"
        get "manage_role"
        get "assignment"
      end
      member do
        get "change_role"
        get "make_assignment"
      end
    end
        
        
    #match "modify_role" => "users#modify_role"
    #match 'all_user' => "users#all_user"
    #match 'change_role' => "users#change_role"

  #match "modify_role" => "users#modify_role"
  #match 'all_user' => "users#all_user"
  #match 'change_role' => "users#change_role"

    
  end
  
  #적 개이적인 라우팅. 위의 문제로 인해 새로운걸 만들때 꼭해주어야함. namesspace 안과밖 모두 써줌.

  
  # See how all your routes lay out with "rake routes"


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  

end
