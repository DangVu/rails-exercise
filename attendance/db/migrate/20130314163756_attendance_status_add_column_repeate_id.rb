class AttendanceStatusAddColumnRepeateId < ActiveRecord::Migration
  def change
    add_column :attendance_statuses, :repeate_id, :int
  end
  
  def up
  end

  def down
  end
end
