class Api::V1::GuestsController < Api::V1::ApplicationController
	def create
		guest = Guest.find_by_token(request.headers["guestToken"])
		if !request.headers["guestToken"].present?
			# guest does not have any token, we have to issue a new one
			unless ["ios","android","web"].include? request.headers["deviceType"]
				sendResponse('custom',"Please share your client details",{})
			else
				if request.headers["timeZone"].present?
					guest = Guest.create!({
								deviceType: request.headers["deviceType"],
								deviceModel: request.headers["deviceModel"],
								deviceId: request.headers["deviceId"],
								timeZone: request.headers["timeZone"],
								ip: request.ip,
							})
					# When new token issued, created code (201) will be sent
					sendResponse('created',"Guest",{token: guest.token})
				else
					sendResponse('custom',"Please share your time zone",{})
				end
			end
		elsif !guest
			# guest have an expired guest token, we will ask to get a new one
			sendResponse('guestExpired',"Invalid guest identity",{})
		else
			# On token vefification success code (200) will be sent
			sendResponse('success',nil,{token: guest.token})
		end
	end
end
