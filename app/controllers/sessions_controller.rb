class SessionsController < ApplicationController
  def create
  	auth = request.env["omniauth.auth"]
  	#raise auth.to_yaml
  	user = User.from_omniauth(auth)
  	if user.persisted?
  		session[:user_id] = user.id
  		redirect_to "/",  notice: "You are already logged!"
  	else
  		redirect_to "/",  notice: user.errors.full_messages.to_s
  	end
  end
end
