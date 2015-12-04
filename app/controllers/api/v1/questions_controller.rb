class Api::V1::QuestionsController < ApplicationController
	before_action :authenticate, except: [:index, :show]
	before_action :set_questions, only: [:show, :update, :destroy]
	before_action :set_poll, only: [:index, :create, :destroy]
	before_action(only: [:destroy,:create]) {|controlador| controlador.authenticate_owner(@poll.user)}

	layout "api/v1/application"

	#GET /polls/1/questions
	def index
		@questions = @poll.questions
	end

	#GET /polls/1/questions/1
	def show
	end

	#POST /polls/1/questions
	def create
		@question = @poll.questions.new(questions_params)
		if @question.save
			render template: "api/v1/questions/show"
		else
			render json: {errors: @question.errors}, status: 422
		end
	end

	#PATCH PUT /polls/1/questions/1
	def update
		if @question.update(questions_params)
			render template: "api/v1/questions/show"
		else
			render json: {errors: @questions.errors}, status: :unprocessable_entity
		end
	end

	#DELETE /polls/1/questions/1
	def destroy
		@question.destroy
		render nothing: true
	end

	private

	def questions_params
		params.require(:question).permit(:description)
	end

	def set_questions
		@question = Question.find(params[:id])
	end

	def set_poll
		@poll = MyPoll.find(params[:poll_id])
	end

end