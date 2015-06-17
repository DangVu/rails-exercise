class RenameRepeatColumnOfAttendanceStatus < ActiveRecord::Migration

  def change
    rename_column(:attendance_statuses, :repeate_id, :repeat_id)
  end
  def up
  end

  def down
  end
end
