class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :severity,     :limit => 32
      t.string :msg
      t.string :object_class,     :limit => 32
      t.integer :object_id
  	  t.datetime :created_at
    end
  end

  def self.down
    drop_table :logs
  end
end
