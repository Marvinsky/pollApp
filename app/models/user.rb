class User < ActiveRecord::Base
	has_many :tokens
	validates :email, presence: true, email: true
	validates :uid, presence: true
	validates :provider, presence: true
end
