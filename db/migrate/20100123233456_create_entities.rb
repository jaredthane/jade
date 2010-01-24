class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :name
      t.string :type
      t.string :home_phone
      t.string :office_phone
      t.string :fax_number
      t.text :address
      t.boolean :active
      t.integer :state_id
      t.string :cell_phone
      t.string :tax_id
      t.string :city
      t.string :email
      t.string :business
      t.string :register
      t.integer :cash_account_id
      t.integer :revenue_account_id
      t.integer :tax_account_id
      t.text :comments
      t.datetime :birth
      t.integer :price_group_id
      t.integer :user_id
      t.integer :site_id
      t.datetime :payday
      t.integer :price_set_id
      t.string :next_receipt_number
      t.integer :client_accounts_group_id
      t.integer :vendor_acccounts_group_id
      t.integer :inventory_account_id
      t.integer :expense_account_id
      t.integer :returns_account_id
      t.integer :discounts_account_id
      t.integer :payables_account_id
      t.string :next_bar_code
    end
  end

  def self.down
    drop_table :entities
  end
end
