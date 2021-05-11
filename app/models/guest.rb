class Guest < ApplicationRecord
	scope :web, -> { where.not(deviceType: ["ios","android"]) }
	scope :mobile, -> { where("deviceId is not null").where(deviceType: ["ios","android"]) }

	before_create :generateToken
	after_create :addGuestId

	def addGuestId
		self.update(token: "#{self.token}t#{self.id}")
	end

	def generateToken
		self.token = loop do
	          token = SecureRandom.hex(20)
	          break token unless Guest.exists?(token: token)
	        end
	end
end
