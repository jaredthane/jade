class MakeProductAndSerialIdsString < ActiveRecord::Migration
  def self.up
  	change_column :base_products, :id, :string
  	change_column :serials, :id, :string
  end

  def self.down
  	change_column :base_products, :id, :integer
  	change_column :serials, :id, :integer
  end
end
