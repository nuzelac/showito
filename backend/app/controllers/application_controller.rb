class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :require_login
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    access_token = ApiKey.find_by(access_token: params[:access_token])
    if !@current_user and access_token
      puts access_token
      @current_user = access_token.user
    end
    
    @current_user
  end

	def require_login
		unless logged_in?
		  flash[:error] = "You must be logged in to access this section"
		  redirect_to log_in_url
		end
	end


	# The logged_in? method simply returns true if the user is logged
	# in and false otherwise. It does this by "booleanizing" the
	# current_user method we created previously using a double ! operator.
	# Note that this is not common in Ruby and is discouraged unless you
	# really mean to convert something into true or false.
	def logged_in?
		!!current_user
	end  

end
