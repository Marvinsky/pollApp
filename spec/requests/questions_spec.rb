require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
	
	before :each do
		@token = FactoryGirl.create(:token)
		@poll = FactoryGirl.create(:poll_with_questions, user:@token.user)
	end

	describe "GET /polls/:poll_id/questions" do
		before :each do
			get "/api/v1/polls/#{@poll.id}/questions"
		end

		it {expect(response).to have_http_status(200)}
		it "display list of questions of the poll" do
			json = JSON.parse(response.body)
			expect(json.length).to eq(@poll.questions.count)
		end

		it "comes id and description" do
			json_array = JSON.parse(response.body)
			question = json_array[0]
			expect(question.keys).to contain_exactly("id", "description")
		end
	end


	describe "POST /polls/:poll_id/questions" do
		context "valid user" do
			before :each do
				post api_v1_poll_questions_path(@poll), {token: @token.token, question: {description: "what is the year of the discovery of america?"}}
			end

			it {expect(response).to have_http_status(200)}
			it "change the  number of questions" do
				expect {
					post api_v1_poll_questions_path(@poll), {token: @token.token, 
												question: {description: "what is the year of the discovery of america?"}}
				}.to change(Question, :count).by(1)
			end
			it "response the created question" do
				json = JSON.parse(response.body)
				expect(json["description"]).to eq("what is the year of the discovery of america?")
			end
		end
		context "invalid user" do
		end
	end
end