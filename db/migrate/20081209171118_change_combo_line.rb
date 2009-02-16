class ChangeComboLine < ActiveRecord::Migration
  def self.up
  	remove_column :combo_lines, :quantity_id
    add_column :combo_lines, :quantity, :int
  end

  def self.down
  end
end
