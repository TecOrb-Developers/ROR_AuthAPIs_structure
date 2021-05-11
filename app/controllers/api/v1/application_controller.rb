class Api::V1::ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token
	include Api::V1::ApplicationHelper

	def require_visitor
		unless user_logged_in?
			unless guest?
				sendResponse('guestExpired',"Invalid guest identity",{})
			else
				@visitor = @guest
				begin
				  Time.zone = @visitor.timeZone
				rescue Exception => e
				end
			end
		else
			@visitor = @user
			begin
			  Time.zone = @session.timeZone
			rescue Exception => e
			end
		end
	end

	def require_login
		unless user_logged_in?
			sendResponse("sessionExpired","Session has been expired",{})
		else
			# updating device details
			if request.headers["deviceType"].present? and request.headers["deviceToken"].present? and request.headers["deviceModel"].present?
				@session.update!({
					device_type: request.headers["deviceType"],
					device_id: request.headers["deviceToken"],
					device_model: request.headers["deviceModel"],
					timeZone: request.headers["timeZone"]
				})
			end
		end
	end

	def user_logged_in?
		# initSidekiq
		@session = UserSession.find_by_token_and_status(request.headers["sessionToken"], true) if request.headers["sessionToken"].present?
		@user = @session.user if @session
	end

	def guest?
		@guest = Guest.find_by_token(request.headers["guestToken"]) if request.headers["guestToken"].present?
	end
end
