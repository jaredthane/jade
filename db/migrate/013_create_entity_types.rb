class CreateEntityTypes < ActiveRecord::Migration
  def self.up
    create_table :entity_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :entity_types
  end
end
