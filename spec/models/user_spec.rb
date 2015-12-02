require 'rails_helper'

RSpec.describe User, type: :model do
	it {should validate_presence_of(:email)}
	it {should_not allow_value("nivramsky@gmail").for(:email)}
	it {should allow_value("nivramsky@gmail.com.com").for(:email)}
	it {should validate_presence_of(:uid)}
	it {should validate_presence_of(:provider)}
	it {should validate_uniqueness_of(:email)}


	it "should create an user if uid and provider does not exists" do
		expect {
			User.from_omniauth({uid: "qsdnofew", provider: "facebook", 
				info: {email: "nivram@gmail.com"}})
		}.to change(User, :count).by(1)
	end

	it "should find an user if the uid and provider exists" do
		user = FactoryGirl.create(:user)
		expect {
			User.from_omniauth({uid: user.uid, provider: user.provider,
			 	info: {email: "uno@gmail.com", name: "mar"}})
		}.to change(User, :count).by(0)
	end

	it "should return the user if the uid and provider exists" do
		user = FactoryGirl.create(:user)
		expect(
			User.from_omniauth({uid: user.uid, provider: user.provider})
		).to eq(user)
	end
end