class AddMovementToLine < ActiveRecord::Migration
  def self.up
    add_column :lines, :movement_id, :integer
  end

  def self.down
    remove_column :lines, :movement_id
  end
end
