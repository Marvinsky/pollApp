class Api::V1::UsersController < ApplicationController
	#POST /users
	def create
		#params = {auth: {provider: 'facebook', uid: 'ssdfe9f', info: {email: ''}}}
		@user = User.from_omniauth(params[:auth])
		@token = Token.create(user: @user)
		render "api/v1/users/show"
	end
end