# encoding: utf-8

class AttendanceController < ApplicationController

  before_filter :signed_in_user
  before_filter :correct_user, only: [:create]
  
  def index
    @selected_month = params[:month]
    @selected_year = params[:year]
    
    time = Time.new

    if @selected_month.nil? || @selected_month.to_i < 1 || @selected_month.to_i > 12
      @selected_month = time.month
    end
    
    if @selected_year.nil? || @selected_year.to_i < 1900 || @selected_year.to_i.to_s != @selected_year
      @selected_year = time.year
    end

    @users = User.all
    @attendance_hash = AttendanceStatus.get_attendance_hash
  end
  
  def edit
    @user = User.find(params[:id])
    email = @user.email
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
    
    @attendance = AttendanceStatus.get_attendance(email, @year, @month, @day)

    #Check if this is repeat absent
    if !@attendance.nil? && !@attendance.repeat_id.nil?
      @repeat = AttendanceRepeat.find(@attendance.repeat_id)
    end
    render  layout: 'ajax'
  end

  def create()
    @selected_month = params[:month]
    @selected_year = params[:year]
    
    #Get all users for sending email
    @users = User.find_all_by_receive_mail(true)

    email = params[:email]
    absent_type = params[:absent_type]
    from_hour = params[:from_hour]
    to_hour = params[:to_hour]
    content = params[:content]
    date = Date.parse(params[:date]) unless params[:date].nil? rescue date = nil
    days = params[:days]
    from_date = Date.parse(params[:from_date]) unless params[:from_date].nil? rescue from_date = nil
    to_date = Date.parse(params[:to_date]) unless params[:to_date].nil? rescue to_date = nil
    
    @user = User.find_by_email(email)
    if (!@user.nil?)
      if (!date.nil? || !days.nil?)
        #Check if attendance is exist
        @attendance = nil
        if (!date.nil?)
          @attendance = AttendanceStatus.get_attendance(email, date.year, date.month, date.day)
        end
        if (@attendance.nil?)
          #Process add new
          if (days.nil?)
            #Add single
            @attendance = AttendanceStatus.save_attendance(nil, email, absent_type, from_hour, to_hour, content, date.to_s(:db), nil)
            flash[:success] = 'Đã lưu vắng mặt.'

            AttendanceMailer.new_absent_email(@users, @user, @attendance, nil).deliver
          else
            #Add repeat
            if (!from_date.nil? && !to_date.nil?)
              @repeat = AttendanceRepeat.save_repeat(nil, days, from_date.to_s(:db), to_date.to_s(:db))

              result = AttendanceStatus.add_attendances(@repeat.id, days, from_date, to_date, email, absent_type, from_hour, to_hour, content, date)
              if(result[:stat] == 1)
                flash[:success] = result[:message]

                @attendance = AttendanceStatus.find_by_repeat_id(@repeat.id)
                AttendanceMailer.new_absent_email(@users, @user, @attendance, @repeat).deliver
              else
                flash[:error] = result[:message]
              end
            else
              flash[:error] = 'Khoảng thời gian không hợp lệ.'
            end
          end
        else
          #Process add update
          if @attendance.repeat_id.nil?
            if (!date.nil?)
              @attendance = AttendanceStatus.save_attendance(@attendance.id, email, absent_type, from_hour, to_hour, content, date.to_s(:db), nil)
              AttendanceMailer.new_absent_email(@users, @user, @attendance, nil).deliver
            else
              flash[:error] = 'Khoảng thời gian không hợp lệ.'
            end
          else
            if (days.nil?)
              save_attendance(@attendance.id, email, absent_type, from_hour, to_hour, content, date.to_s(:db), nil)
            else
              if (!from_date.nil? && !to_date.nil?)
                @repeat = AttendanceRepeat.save_repeat(@attendance.repeat_id, days, from_date.to_s(:db), to_date.to_s(:db))
                AttendanceStatus.where(repeat_id: @attendance.repeat_id).delete_all

                result = AttendanceStatus.add_attendances(@attendance.repeat_id, days, from_date, to_date, email, absent_type, from_hour, to_hour, content, date)
                if(result[:stat] == 1)
                  flash[:success] = result[:message]

                  @attendance = AttendanceStatus.find_by_repeat_id(@repeat.id)
                  AttendanceMailer.new_absent_email(@users, @user, @attendance, @repeat).deliver
                else
                  flash[:error] = result[:message]
                end
              end
            end
          end
        end
      end
    else
      flash[:error] = 'Không tìm thấy người dùng nào với địa chỉ email: ' + email
    end

    redirect_to root_path + "?month=#{@selected_month}&year=#{@selected_year}"
  end

  private
  def signed_in_user
    if !signed_in?
      redirect_to login_url
    end
  end

  def correct_user
    email = params[:email]
    user = User.find_by_email(email)
    if !can_edit_attendance? user
      flash[:error] = "Truy cập bị từ chối!"
      redirect_to root_path
    end
  end
end
