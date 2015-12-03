require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :request do

	before :each do
		@token = FactoryGirl.create(:token, expires_at: DateTime.now + 1.month)
		@poll = FactoryGirl.create(:poll_with_questions, user:@token.user)
		@question = @poll.questions[0]
	end

	let(:valid_params){{description: "Ruby", question_id: @question.id}}

	describe "POST /polls/:poll_id/answers" do
		context "valid user" do
			before :each do
				post api_v1_poll_answers_path(@poll),
				{answer: valid_params, token: @token.token}
			end

			it {expect(response).to have_http_status(200)}

			it "change the counter to +1" do
				expect{
					post api_v1_poll_answers_path(@poll),
					{answer: valid_params, token: @token.token}
				}.to change(Answer,:count).by(1)
			end

			it "response the answer created" do
				puts "\n\n -- #{response.body} -- \n\n"
				json = JSON.parse(response.body)
				expect(json["description"]).to eq(valid_params[:description])
			end
		end
		context "invalid user" do
		end
	end

	describe "PATCH/PUT  /polls/:poll_id/questions/:answer_id" do
		context "valid user token" do
		end
	end

	describe "DELETE /polls/:poll_id/questions/:answer_id" do
	end
end