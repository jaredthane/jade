class CreateUserPrivileges < ActiveRecord::Migration
  def self.up
    create_table :user_privileges do |t|
      t.references :user
      t.references :privilege

      t.timestamps
    end
  end

  def self.down
    drop_table :user_privileges
  end
end
