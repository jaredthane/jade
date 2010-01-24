class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.integer :parent_id
      t.integer :entity_id
      t.string :number
      t.integer :modifier
      t.decimal :balance
      t.boolean :is_parent

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
