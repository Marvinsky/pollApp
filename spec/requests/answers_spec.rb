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
				expect(json["data"]["attributes"]["description"]).to eq(valid_params[:description])
			end
		end
		context "invalid user" do
		end
	end

	describe "PATCH/PUT  /polls/:poll_id/questions/:answer_id" do
		context "valid user token" do
			before :each do
				@answer = FactoryGirl.create(:answer, question:@question)
				#puts "\n\nasdada -- #{@answer} -- \n\n"
				put api_v1_poll_answer_path(@poll,@answer), {token: @token.token,answer: {description: "C++ Rocks"}}
			end
			it { expect(response).to have_http_status(200)}
			it "update the description" do
				#json = JSON.parse(response.body)
				#expect(json["description"]).to eq("C++ Rocks")
				@answer.reload
				expect(@answer.description).to eq("C++ Rocks")
			end
		end
	end

	describe "DELETE /polls/:poll_id/questions/:answer_id" do
		context "valid user token" do
			before :each do
				@answer = FactoryGirl.create(:answer, question:@question)
			end
			it {
				delete api_v1_poll_answer_path(@poll,@answer), {token: @token.token}
				expect(response).to have_http_status(200)
			}
			it "delete and display changed by -1" do
				expect{
					delete api_v1_poll_answer_path(@poll,@answer), {token: @token.token}
				}.to change(Answer,:count).by(-1)
			end
			it "changed by 0 when no token is send" do
				expect{
					delete api_v1_poll_answer_path(@poll,@answer)
				}.to change(Answer,:count).by(0)
			end
		end		
	end
end