class FixColumnNameType < ActiveRecord::Migration
  def change
    rename_column(:attendance_statuses, :type, :absent_type)
  end
  def up
  end

  def down
  end
end
