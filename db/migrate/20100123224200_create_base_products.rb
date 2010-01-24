class CreateBaseProducts < ActiveRecord::Migration
  def self.up
    create_table :base_products do |t|
      t.string :id
      t.string :name
      t.text :description
      t.integer :vendor_id
      t.integer :unit_id
      t.string :location
      t.string :model
      t.string :manufacturer
      t.boolean :uses_serial
      t.string :type
      t.integer :category_id
      t.integer :revenue_account_id
    end
  end

  def self.down
    drop_table :base_products
  end
end
