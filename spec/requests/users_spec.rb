require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
	describe "POST /users" do
		before :each do
			auth = {provider: "facebook",
					uid: "3243242k23f",
					info: {email: "email1@gmail.com"}}
			post "/api/v1/users", {auth: auth}
		end


		it "response with 200 code" do
			have_http_status(200)
		end

		it {change(User, :count).by(1)}

		it "responds with the user found or created" do
			json = JSON.parse(response.body)
			#puts "\n\n -- #{json} --\n\n"
			expect(json["email"]).to eq("email1@gmail.com")
		end
	end	
end