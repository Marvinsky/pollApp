require 'rails_helper'

RSpec.describe Api::V1::MyPollsController, type: :request do
	describe "GET /polls" do
		before :each do
			FactoryGirl.create_list(:my_poll, 10)
			get "/api/v1/polls"
		end


		it {have_http_status(200)}
		it "send to the list of polls" do
			json = JSON.parse(response.body)
			#puts "\n\n--- #{json} ---\n\n"
			expect(json.length).to eq(MyPoll.count)
		end
	end	

	describe "GET /api/v1/polls/:id" do
		before :each do
			@poll = FactoryGirl.create(:my_poll)
			get "/api/v1/polls/#{@poll.id}"
		end

		it {have_http_status(200)}
		it "should display the poll info" do
			json = JSON.parse(response.body)
			expect(json["id"]).to eq(@poll.id)
		end

		it "should send the attributes of poll" do
			json = JSON.parse(response.body)
			expect(json.keys).to contain_exactly("id","title","description","user_id","expires_at")
		end
	end

	describe "POST /api/v1/polls" do
		context "valid token" do
			before :each do
				@token = FactoryGirl.create(:token)
				#puts "\n\n -- #{@token.inspect}  -- \n\n"
				post "/api/v1/polls", {token: @token.token, poll: {title: "hola mundo", description: "Helloworlwithmorethan20letters",expires_at:DateTime.now}}
			end
			it {have_http_status(200)}
			it "create new poll" do
				expect {
					post "/api/v1/polls", {token: @token.token, poll: {title: "hola mundo", description: "Helloworlwithmorethan20letters",expires_at:DateTime.now}}
				}.to change(MyPoll, :count).by(1)
			end
			it "respons with the poll created" do
				json = JSON.parse(response.body)
				expect(json["title"]).to eq("hola mundo")
			end
		end
		context "invalid token" do
			before :each do
				token = FactoryGirl.create(:my_poll)
				post = "/api/v1/polls"
			end

		end
	end
end