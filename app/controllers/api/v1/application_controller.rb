class Api::V1::ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	include Api::V1::ApplicationHelper

	def require_visitor
		unless guest?
			sendResponse('guestExpired',"Invalid guest identity",{})
		else
			@visitor = @guest
			begin
			  Time.zone = @visitor.timeZone
			rescue Exception => e
			end
		end
	end

	def guest?
		@guest = Guest.find_by_token(request.headers["guestToken"]) if request.headers["guestToken"].present?
	end
end
