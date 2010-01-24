class ChangeSerialIdOnBaseLine < ActiveRecord::Migration
  def self.up
  	rename_column :base_lines, :serial_number_id, :serial_id
  end

  def self.down
  	rename_column :base_lines, :serial_id, :serial_number_id
  end
end
