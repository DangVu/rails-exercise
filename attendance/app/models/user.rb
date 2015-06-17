class User < ActiveRecord::Base
 attr_accessible :fullname, :email, :can_edit
 has_many :attendance_status

  has_one :google, :class_name=>"GoogleToken", :dependent=>:destroy 
end
