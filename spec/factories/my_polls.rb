FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :sequence_user
	expires_at "2015-12-02 00:21:51"
	title "MyStringaa"
	description "MyTextaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	factory :poll_with_questions do
		title "Poll with questions"
		description "MyTest wity questions in this world"
		questions {build_list :question, 2}	
	end
  end
end
