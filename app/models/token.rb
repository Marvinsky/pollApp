class Token < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  private
  def generate_token
  	begin
  		self.token = SecureRandom.hex
  	end while Token.where(token: self.token).any? #any: true is the array is not empty
  	self.expires_at = 1.month.from_now
  end
end
