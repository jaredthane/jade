class AddComboLineType < ActiveRecord::Migration
  def self.up
  	create_table :combo_line_types do |t|
      t.string :name
    end
    add_column :combo_lines, :combo_line_type_id, :int
  end

  def self.down
  end
end
