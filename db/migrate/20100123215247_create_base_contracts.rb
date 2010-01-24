class CreateBaseContracts < ActiveRecord::Migration
  def self.up
    create_table :base_contracts do |t|
      t.integer :site_id
      t.decimal :total
      t.text :comments
      t.datetime :deleted_at
      t.integer :deleted_by
      t.integer :created_by
      t.integer :updated_by
      t.datetime :completed_at
      t.datetime :completed_by
      t.string :type
      
      #For Orders(Sales, Purchases, and Transfers)
      t.decimal :paid
      t.integer :next_id
      t.string :document_filename
      t.datetime :document_generated
      t.string :document_number
      t.integer :entity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :base_contracts
  end
end