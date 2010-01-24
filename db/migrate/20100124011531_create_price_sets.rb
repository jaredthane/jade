class CreatePriceSets < ActiveRecord::Migration
  def self.up
    create_table :price_sets do |t|
    t.integer :price_group_id
    t.integer :entity_id
    end
  end

  def self.down
    drop_table :price_sets
  end
end