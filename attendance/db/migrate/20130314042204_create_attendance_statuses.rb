class CreateAttendanceStatuses < ActiveRecord::Migration
  def change
    create_table :attendance_statuses do |t|
      t.column :email, :string
      t.column :time, :date
      t.column :type, :string
      t.column :absent_time, :string
      t.column :content, :string
      t.timestamps
    end
  end
end
