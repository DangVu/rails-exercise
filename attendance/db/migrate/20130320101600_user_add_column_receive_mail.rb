class UserAddColumnReceiveMail < ActiveRecord::Migration
  def up
    add_column :users, :receive_mail, :bool
  end

  def down
    remove_column(:users, :receive_mail)
  end
end
