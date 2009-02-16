class CreateComboLines < ActiveRecord::Migration
  def self.up
    create_table :combo_lines do |t|
      t.references :product
      t.references :combo
      t.references :quantity
      t.references :serialized_product

      t.timestamps
    end
  end

  def self.down
    drop_table :combo_lines
  end
end
