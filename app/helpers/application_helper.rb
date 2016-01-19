module ApplicationHelper
	def user_signed_in?
		#return true if user is logged and false otherwise
		!current_user.nil? #true if the object is nil false otherwise
	end

	def current_user
		#return nil is user is not logged and logged user otherwise
		User.find_by_id(session[:user_id])
	end
end
