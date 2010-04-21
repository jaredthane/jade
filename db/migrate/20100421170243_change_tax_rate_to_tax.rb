class ChangeTaxRateToTax < ActiveRecord::Migration
  def self.up
    remove_column :orders, :tax_rate
    add_column :orders, :tax, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    add_column :orders, :tax_rate, :decimal, :precision => 8, :scale => 2, :default => 0.0
    remove_column :orders, :tax
  end
end
