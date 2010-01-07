class CreateProcesses < ActiveRecord::Migration
  def self.up
  	create_table :processes do |t|
      t.string :name
    end
  end

  def self.down
  	drop_table :processes
  end
end
