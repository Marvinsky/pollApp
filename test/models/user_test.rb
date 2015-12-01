require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should create an user" do
  	u = User.new(email: "nivramsky@gmail.com", name:"marvin")
  	assert_not u.save
  end

  test "should create an user without email" do
  	u = User.new(name:"marvin")
  	assert_not u.save
  end

  test "should not create an user without uid" do
  	u = User.new(email:"nivramsky@gmail.com", name: "marvin",provider:"provider")
  	assert_not u.save
  end

end
