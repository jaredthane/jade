class ChangeCreatedByToCreatedById < ActiveRecord::Migration
  def self.up
  	rename_column :production_orders, :created_by, :created_by_id
  	rename_column :production_orders, :started_by, :started_by_id
  	rename_column :production_orders, :finished_by, :finished_by_id
  end

  def self.down
  	rename_column :production_orders, :created_by_id, :created_by
  	rename_column :production_orders, :started_by_id, :started_by
  	rename_column :production_orders, :finished_by_id, :finished_by
  end
end
