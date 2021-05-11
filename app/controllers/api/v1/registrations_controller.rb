class Api::V1::RegistrationsController < Api::V1::ApplicationController
	before_action :require_visitor

	def create
		begin
			@user = User.new(user_params)
			if @user.save && @user.authenticate(user_params[:password])
				user = @user.as_json({
						only: [:id, :email, :fullName, :contactNumber,:countryCode,:activated]
					})
				sendResponse('created',"User",{user: user})
			else
				sendResponse('custom',"#{@user.errors.full_messages.join(", ")}",{})
			end
		rescue Exception => e
			sendResponse('custom',e,{})
		end
		
	end

	private
	def user_params
		params.require(:user).permit(:fullName, :email, :password, :countryCode,:contactNumber)
	end
end
