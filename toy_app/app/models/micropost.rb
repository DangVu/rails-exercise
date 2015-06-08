class Micropost < ActiveRecord::Base
	belongs_to :user
	validates :content, length: { maximum: 10 },
				presence: true
	validates :email, uniqueness: false
end
