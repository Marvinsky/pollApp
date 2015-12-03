FactoryGirl.define do
  factory :question do
    association :my_poll, factory: :my_poll
	description "What is your favorite browser?"
  end

end
