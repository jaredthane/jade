class Create < ActiveRecord::Migration
  def self.up
	  create_table :roles_users do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
  end
end
