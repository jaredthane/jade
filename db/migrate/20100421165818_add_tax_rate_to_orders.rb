class AddTaxRateToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :subject_to_tax
    remove_column :lines, :sales_tax
    remove_column :lines, :tax
    add_column :orders, :tax_rate, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    add_column :orders, :subject_to_tax, :boolean
    add_column :lines, :sales_tax, :decimal, :precision => 8, :scale => 2, :default => 0.0
    add_column :lines, :tax, :decimal, :precision => 8, :scale => 2, :default => 0.0
    remove_column :orders, :tax_rate
  end
end
