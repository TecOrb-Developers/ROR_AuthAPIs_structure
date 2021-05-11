class Api::V1::SessionsController < Api::V1::ApplicationController
	before_action :require_visitor,:findUser, only: [:create]

	def create
		begin
			if @user.authenticate(params[:password])
				loginUser
			else
				sendResponse('unauthorized',"User",{})
			end
		rescue Exception => e
			sendResponse('unauthorized',"User",{})
		end
	end

	private

	def findUser
		@user = User.find_by_email(params[:email]) if params[:email].present?
		unless @user
			sendResponse('not',"User",{})
		end
	end

	def loginUser
		@user.user_sessions.first.destroy if @user.user_sessions.count > 5
		updateDevice
		managerVisitor
		sendResponse('created',"User",userJson)
	end

	def updateDevice
		@session = @user.user_sessions.create!({
						device_id: request.headers["deviceToken"],
						device_type: request.headers["deviceType"],
						device_model: request.headers["deviceModel"],
						timeZone: request.headers["timeZone"]
					})
	end
	
	def managerVisitor
		if @visitor.class.name=="Guest"
			# do stuff here for guest activities 
			# @visitor.destroy
		end
	end

	def userJson
		result = {
					user: @user.as_json({
						only: [:id, :email, :fullName, :contactNumber,:countryCode,:activated]
					}).merge({
						accessToken: @session.token
					})
				}
	end



end
