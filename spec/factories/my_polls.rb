FactoryGirl.define do
  factory :my_poll do
    association :user, factory: :user
	expires_at "2015-12-02 00:21:51"
	title "MyStringaa"
	description "MyTextaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  end
end
