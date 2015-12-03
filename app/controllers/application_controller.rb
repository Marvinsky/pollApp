class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  #before_action :authenticate

  protected

  def authenticate
  	token_str = params[:token]
  	token = Token.find_by(token: token_str)
  	if token == nil || !token.is_valid?
  		render json: {error: "Token is invalid"}, status: :unauthorized
  	else
  		@current_user = token.user
  	end
  end

  def authenticate_owner(owner)
    if owner != @current_user
      render json: {errors: "Not authorized to use the resource poll"}, status: 401
    end
  end


end