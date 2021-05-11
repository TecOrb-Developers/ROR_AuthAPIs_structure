class UserSession < ApplicationRecord
	belongs_to :user
	scope :active, -> { where(status: true) }
	scope :mobile, -> { where("device_id is not null and device_type IN (?)", ["ios","android"])}
	scope :android, -> { where("device_id is not null and device_type=?", "ios")}
	scope :ios, -> { where("device_id is not null and device_type=?", "android")}
	scope :web, -> { where.not(device_type: ["ios","android"]) }
	before_create :generateToken
	after_create :addSessionId


	def addSessionId
		self.update(token: "#{self.token}s#{self.id}")
	end

	def generateToken
		self.token = loop do
			newToken = SecureRandom.hex(10)
			break newToken unless UserSession.exists?(token: newToken)
		end
	end
end
