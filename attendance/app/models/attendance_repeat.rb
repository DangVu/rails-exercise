class AttendanceRepeat < ActiveRecord::Base
  attr_accessible :id, :from_date, :to_date, :days
  has_many :attendance_status

  def self.save_repeat(id, days, from_date, to_date)
    repeat = self.find(id) rescue repeat = self.new
    repeat.days = days.join(',')
    repeat.from_date = from_date
    repeat.to_date = to_date
    repeat.save()
    repeat
  end
end
