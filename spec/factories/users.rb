FactoryGirl.define do
	factory :user do
		email "nivramsky@gmail.com"
		name "name_string"
		provider "provider_string"
		uid "uid_string"
		factory :dummy_user do
			email "ememo@gmail.com"
			name "ememo_string"
			provider "ememo_provider_string"
			uid "ememo_uid_string"
		end
		factory :sequence_user do
			sequence(:email) {|n| "person#{n}@example.com"}
			name "marcos"
			provider "facebook"
			uid "423nrlnrlnf"
		end
	end
end