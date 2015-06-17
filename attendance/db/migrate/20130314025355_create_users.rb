class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :fullname, :string
      t.column :email, :string
      t.column :can_edit, :bool
      t.timestamps
    end
  end
end
