class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # 잘못된 접근시 리다이렉트 시킴. 
  rescue_from CanCan::AccessDenied do |exception|  
    flash[:error] = "Access denied!"  
    redirect_to root_url  
  end
end


