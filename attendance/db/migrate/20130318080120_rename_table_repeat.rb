class RenameTableRepeat < ActiveRecord::Migration
  def up
    rename_table(:attendance_repeates, :attendance_repeats)
  end

  def down
  end
end
