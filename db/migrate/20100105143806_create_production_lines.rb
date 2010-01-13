class CreateProductionLines < ActiveRecord::Migration
  def self.up
  	create_table :jobs do |t|
      t.references :process
	  	t.references :job
      t.integer :quantity
    end
  end
  def self.down
  	drop_table :production_lines
  end
end
