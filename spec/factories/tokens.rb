FactoryGirl.define  do
	factory :token do
		token "423ljklnfl32rkln32"
		expires_at "2015-12-28 19:14:47"
		association :user, factory: :user
	end
end