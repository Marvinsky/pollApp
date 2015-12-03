class Api::V1::QuestionsController < ApplicationController
	before_action :authenticate, except: [:index, :show]
	before_action :set_questions, only: [:show, :update, :delete]
	before_action :set_poll, only: [:index, :create, :delete]


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
	end

	#DELETE /polls/1/questions/1
	def delete
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