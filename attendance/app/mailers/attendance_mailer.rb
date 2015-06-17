# encoding: utf-8

class AttendanceMailer < ActionMailer::Base
  helper :attendance
  
  default from: "ebook2c@gmail.com"

  def new_absent_email(users, user, attendance, repeat)
    user_emails = users.map(&:email)
    @user = user
    @attendance = attendance
    @repeat = repeat
    mail(to: user_emails, subject: "#{@user.fullname} vắng mặt")
  end
end
