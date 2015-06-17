# encoding: utf-8

class AttendanceStatus < ActiveRecord::Base
  attr_accessible :email, :time, :absent_type, :absent_time, :content, :repeat_id
  belongs_to :user
  belongs_to :attendance_repeate

  def self.get_attendance_hash
    attendance_hash = Hash.new
    #Todo: search only in a date range
    attendances = AttendanceStatus.all
    attendances.each do |attendance|
      email = attendance.email
      day = attendance.time.to_time.day
      month = attendance.time.to_time.month
      year = attendance.time.to_time.year

      key = email + year.to_s + month.to_s + day.to_s
      key_sum_late = email + year.to_s + month.to_s + '-late'
      key_sum_absent = email + year.to_s + month.to_s + '-absent'

      attendance_hash[key] = attendance

      if attendance.absent_type == 'late'
        if attendance_hash[key_sum_late].nil?
          attendance_hash[key_sum_late] = 1
        else
          attendance_hash[key_sum_late] += 1
        end
      end

      if attendance.absent_type == 'all_day'  || attendance.absent_type == 'morning' || attendance.absent_type == 'afternoon'
        if attendance_hash[key_sum_absent].nil?
          attendance_hash[key_sum_absent] = 1
        else
          attendance_hash[key_sum_absent] += 1
        end
      end
    end
    attendance_hash
  end

  def self.get_attendance(email, year, month, day)
    AttendanceStatus.find(:first, :conditions => "email = '#{email}' AND year(time) = #{year} AND month(time) = #{month} AND day(time) = #{day}")
  end

  def self.add_attendances(repeat_id, days, from_date, to_date, email, absent_type, from_hour, to_hour, content, date)
    #Add attendance
    has_created = false
    from_date.upto(to_date) do |date|
      if (days.include?((date.wday + 1).to_s))
        self.save_attendance(nil, email, absent_type, from_hour, to_hour, content, date.to_s(:db), repeat_id)
        has_created = true
      end
    end
    if has_created
      {stat: 1, message: 'Đã lưu vắng mặt.'}
    else
      {stat: 0, message: 'Không tìm thấy ngày nào phù hợp trong khoảng thời gian bạn đã chọn. Không vắng mặt nào được lưu.'}
    end
  end

  def self.save_attendance(id, email, absent_type, from_hour, to_hour, content, time, repeat_id)
    attendance = AttendanceStatus.find_or_create_by_id(id)
    attendance.email = email
    attendance.absent_type = absent_type
    attendance.from_hour = from_hour
    attendance.to_hour = to_hour
    attendance.content = content
    attendance.time = time
    attendance.repeat_id = repeat_id
    attendance.save()
    attendance
  end
end
