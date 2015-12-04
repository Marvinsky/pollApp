class Api::V1::AnswersController < ApplicationController
	before_action :authenticate, except: [:index, :show]
	before_action :set_answers, only: [:show, :update, :destroy]
	before_action :set_poll, only: [:index, :create, :destroy]
	before_action(only: [:destroy,:create]) {|controlador| controlador.authenticate_owner(@poll.user)}

	layout "api/v1/application"

	#POST /polls/1/questions
	def create
		@answer = Answer.new(answer_params)
		if @answer.save
			render template: "api/v1/answers/show"
		else
			render json: {errors: @answer.errors}, status: 422
		end
	end

	#PATCH PUT /polls/1/questions/1
	def update
		if @answer.update(answer_params)
			render template: "api/v1/answers/show"
		else
			render json: {errors: @answer.errors}, status: :unprocessable_entity
		end
	end

	#DELETE /polls/1/questions/1
	def destroy
		@answer.destroy
		head :ok
	end

	private

	def answer_params
		params.require(:answer).permit(:description, :question_id)
	end

	def set_answers
		@answer = Answer.find(params[:id])
	end

	def set_poll
		@poll = MyPoll.find(params[:poll_id])
	end

end