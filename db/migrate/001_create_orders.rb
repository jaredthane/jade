class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :vendor
      t.references :client
      t.date :received
      t.date :ordered
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
