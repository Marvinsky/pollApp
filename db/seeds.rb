# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email:"nivramsky@gmail.com", uid: "32dfa4328uoja", provider:"facebook")
poll = MyPoll.create(title:"Programming language you prefer", description:"We want to know what programming languages are the most used.",
					expires_at: DateTime.now + 1.year,user:user)
question = Question.create(description: "Do you like the performance of your language programming?", my_poll:poll)
answer = Answer.create(description: "a)",question:question)
