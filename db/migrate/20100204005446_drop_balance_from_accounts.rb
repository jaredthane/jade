class DropBalanceFromAccounts < ActiveRecord::Migration
  def self.up
  	remove_column :accounts, :balance
  end

  def self.down
  	add_column :accounts, :balance, :decimal
  end
end
