class SessionsController < ApplicationController
  def create
  	auth = request.env["omniauth.auth"]
  	raise auth.to_yaml
  end
end
