class CreateAttendanceRepeates < ActiveRecord::Migration
  def change
    create_table :attendance_repeates do |t|
      t.column :days, :string
      t.column :from_date, :date
      t.column :to_date, :date
      t.timestamps
    end
  end
end
