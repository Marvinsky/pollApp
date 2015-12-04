require 'rails_helper'

RSpec.describe Api::V1::MyPollsController, type: :request do
	describe "GET /polls" do
		before :each do
			FactoryGirl.create_list(:my_poll, 10)
			get "/api/v1/polls"
		end


		it {expect(response).to have_http_status(200)}
		it "send to the list of polls" do
			#puts "\n\n -- #{response.body} -- \n\n"
			json = JSON.parse(response.body)
			#puts "\n\n--- #{json} ---\n\n"
			expect(json["data"].length).to eq(MyPoll.count)
		end
	end	

	describe "GET /api/v1/polls/:id" do
		before :each do
			@poll = FactoryGirl.create(:my_poll)
			get "/api/v1/polls/#{@poll.id}"
		end

		it {expect(response).to have_http_status(200)}
		it "should display the poll info" do
			json = JSON.parse(response.body)
			expect(json["data"]["id"]).to eq(@poll.id)
		end

		it "should send the attributes of poll" do
			json = JSON.parse(response.body)
			expect(json["data"].keys).to contain_exactly("id","title","description","user_id","expires_at")
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
				expect(json["data"]["title"]).to eq("hola mundo")
			end
		end
		context "invalid token" do
			before :each do
				token = FactoryGirl.create(:my_poll)
				post "/api/v1/polls"
			end
			it {
				json = JSON.parse(response.body)
				expect(response).to have_http_status(401)
			}
		end

		context "test invalid parameters" do
			before :each do
				@token = FactoryGirl.create(:token)
				#puts "\n\n #{@token.inspect} \n\n"
				post "/api/v1/polls", {token: @token.token, 
					poll: {title: "hola mundo", 
					#description: "Helloworlwithmorethan20letters",
					expires_at:DateTime.now}}
			end
			it {expect(response).to have_http_status(422)}
			it "errors" do
				json = JSON.parse(response.body)
				expect(json["errors"]).to_not be_empty
			end
		end
	end

	describe "PATCH /polls/:id" do
		context "valid user token" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user:@token.user)
				patch api_v1_poll_path(@poll), {token: @token.token, poll: {title: "Nuevo titulo"}}
			end
			it {expect(response).to have_http_status(200)}

			it "update the poll" do
				json = JSON.parse(response.body)
				#puts "\n\n -- #{json} -- \n\n"
				expect(json["data"]["title"]).to eq("Nuevo titulo")
			end
		end
		context "token of user that does not create the poll" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
				patch api_v1_poll_path(@poll), {token: @token.token, poll: {title: "Nuevo titulo2"}}

			end
			it {expect(response).to have_http_status(401)}
			it "update the poll will not work" do
				json = JSON.parse(response.body)
				expect(json["errors"]).to_not be_empty
			end
		end
	end


	describe "DELETE /polls/:id" do
		context "valid user token" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user:@token.user)
			end
			it {
				delete api_v1_poll_path(@poll), {token: @token.token}
				expect(response).to have_http_status(200)
			}

			it "delete the poll" do
				expect{
					delete api_v1_poll_path(@poll), {token: @token.token}
					json = JSON.parse(response.body)
				}.to change(MyPoll, :count).by(-1)
			end
		end
		context "token of user that does not create the poll" do
			before :each do
				@token = FactoryGirl.create(:token, expires_at: DateTime.now + 10.minutes)
				@poll = FactoryGirl.create(:my_poll, user: FactoryGirl.create(:dummy_user))
				delete api_v1_poll_path(@poll), {token: @token.token}

			end
			it {expect(response).to have_http_status(401)}
			it "update the poll will not work" do
				puts "\n\n -- #{response.body} -- \n\n"
				json = JSON.parse(response.body)
				expect(json["errors"]).to_not be_empty
			end
		end
	end
end