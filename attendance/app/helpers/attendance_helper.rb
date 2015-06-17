# encoding: utf-8

module AttendanceHelper

  def absent_type_selected(attendance, absent_type)
    if (attendance)
      attendance.absent_type == absent_type ? "selected" : ''
    end
  end

  def absent_text(key)
    if !(@attendance_hash[key].nil?)
      absent_type = @attendance_hash[key].absent_type
      case absent_type
      when 'all_day'
        '2/2'
      when 'morning'
        '1/2'
      when 'afternoon'
        '2/1'
      when 'time'
        '--'
      end
    end
  end

  def absent_type(key)
    if !(@attendance_hash[key].nil?)
      @attendance_hash[key].absent_type
    end
  end

  def absent_type_text(type)
    case type
      when 'all_day'
        'Cả ngày'
      when 'morning'
        'Buổi sáng'
      when 'afternoon'
        'Buổi chiều'
      when 'time'
        'Giờ'
      when 'late'
        'Đi muộn'
      end
  end

  def absent_title(key)
    if !(@attendance_hash[key].nil?)
      absent_type = @attendance_hash[key].absent_type
      content = @attendance_hash[key].content
      from_hour = @attendance_hash[key].from_hour
      to_hour = @attendance_hash[key].to_hour
      
      case absent_type
      when 'all_day'
        'Cả ngày: ' + content
      when 'morning'
        'Buổi sáng: ' + content
      when 'afternoon'
        'Buổi chiều: ' + content
      when 'time'
        "Từ (#{from_hour}h tới #{to_hour}h): " + content
      when 'late'
        'Đi muộn: ' + content
      end
    end
  end

  def absent_repeat_checked(day)
    if !@repeat.nil?
      if @repeat.days.include?(day.to_s)
        "checked"
      end
    end
  end

  def can_edit_attendance?(user)
    if !user.nil? && (current_user.can_edit == true || user.email == current_user.email)
      return true
    else
      return false
    end
  end
end
