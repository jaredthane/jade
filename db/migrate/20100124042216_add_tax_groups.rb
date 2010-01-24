class AddTaxGroups < ActiveRecord::Migration
  def self.up
    create_table :tax_groups do |t|
		  t.string  :name
		  t.decimal :rate
    end
    add_column :entities, :tax_group_id, :integer
  end

  def self.down
  	drop_table :tax_groups
    remove_column :entities, :tax_group_id
  end
end
