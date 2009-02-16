class CreateMovementTypes < ActiveRecord::Migration
  def self.up
    create_table :movement_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :movement_types
  end
end
