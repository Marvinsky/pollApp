class Api::V1::MyPollsController < ApplicationController
	before_action :authenticate, only: [:create, :update, :destroy]
	
	def index
		@polls = MyPoll.all
	end

	def show
		@poll = MyPoll.find(params[:id])
	end
	
	#POST /polls
	def create
		@poll = @current_user.my_polls.new(my_polls_params)
		if @poll.save
			render "api/v1/my_polls/show"
		else
			render json: {errors: @poll.errors.full_messages}, status: :unprocessable_entity
		end
	end

	def update
	end

	def destroy
	end

	private
	def my_polls_params
		params.require(:poll).permit(:title, :description,:expires_at)
	end
end