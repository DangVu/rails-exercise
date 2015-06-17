class User < ActiveRecord::Base
	attr_accessor :remember_token
	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: {maximum: 255},
					format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
					uniqueness: true
	has_secure_password
	validates :password, allow_blank: true, length: {minimum: 6}
	mount_uploader :picture, PictureUploader

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end
end
