class RenamAbsentTime < ActiveRecord::Migration

  def change
    rename_column(:attendance_statuses, :absent_time, :from_hour)
    change_column :attendance_statuses, :from_hour,:integer
    add_column :attendance_statuses, :to_hour,:integer
  end
  
  def up
  end

  def down
  end
end
