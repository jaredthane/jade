class CreateRightRoles < ActiveRecord::Migration
  def self.up
    create_table :right_roles do |t|
    t.integer "role_id"
    t.integer "right_id"
    end
  end

  def self.down
    drop_table :right_roles
  end
end
