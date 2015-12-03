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

	describe "GET /polls/:poll_id/questions/:question_id" do
		before :each do
			@question = @poll.questions[0]
			get "/api/v1/polls/#{@poll.id}/questions/#{@question.id}", {token: @token.token}
		end

		it {
			expect(response).to have_http_status(200)
		}
		it "should display the question info" do
			json = JSON.parse(response.body)
			expect(json["id"]).to eq(@question.id)
		end

		it "should send the attributes of question" do
			json = JSON.parse(response.body)
			expect(json.keys).to contain_exactly("id","description")
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
			before :each do
				new_user = FactoryGirl.create(:dummy_user)
				@new_token = FactoryGirl.create(:token, user:new_user, expires_at: DateTime.now + 1.month)
				post api_v1_poll_questions_path(@poll), {token: @new_token.token,
					question: {description: "what is the year of the discovery of america?"}}
			end

			it {expect(response).to have_http_status(401)}
			it "should not change the number of questions" do
				expect{ post api_v1_poll_questions_path(@poll), {token: @new_token.token,
					question: {description: "what is the year of the discovery of america?"}}
				}.to change(Question, :count).by(0)
			end
		end
	end

	describe "PATCH/PUT  /polls/:poll_id/questions/:question_id" do
		context "valid user token" do
			before :each do
				@question = @poll.questions[0] 
				#patch "/api/v1/polls/#{@poll.id}/questions/#{@question.id}", {token: @token.token, question: {description: "What is a triangle issoseless?"}}
				patch api_v1_poll_question_path(@poll,@question),{question: {description: "What is a triangle issoseless?"},token: @token.token}				
			end

			it {expect(response).to have_http_status(200)}
			it "update the description" do
				
				json = JSON.parse(response.body)
				expect(json["description"]).to eq("What is a triangle issoseless?")
			end
		end
	end

	describe "DELETE /polls/:poll_id/questions/:question_id" do
		before :each do
			@question = @poll.questions[0]
		end

		it "response http" do
			delete api_v1_poll_question_path(@poll,@question), {token: @token.token}
			expect(response).to have_http_status(200)
		end

		it "delete a question" do
			#delete "/api/v1/polls/#{@poll.id}/questions/#{@question.id}", {token: @token.token}
			delete api_v1_poll_question_path(@poll,@question), {token: @token.token}
			expect(Question.where(id: @question.id)).to be_empty
		end
		it "reduce the quetions in one" do
			expect{
				delete api_v1_poll_question_path(@poll,@question)
			}.to change(Question,:count).by(0)
		end
	end

end