class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.references :order
      t.integer :amount
      t.date :date
      t.references :payment_method
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
