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
end