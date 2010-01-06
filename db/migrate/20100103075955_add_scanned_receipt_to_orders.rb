class AddScannedReceiptToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :scanned_receipt_file_name, :string
    add_column :orders, :scanned_receipt_content_type, :string
    add_column :orders, :scanned_receipt_file_size, :integer
  end

  def self.down
    remove_column :orders, :scanned_receipt_file_name
    remove_column :orders, :scanned_receipt_content_type
    remove_column :orders, :scanned_receipt_file_size
  end
end
