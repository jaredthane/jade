class PutLineIDsBackOnMovements < ActiveRecord::Migration
  def self.up
        add_column :movements, :line_id, :integer
  end

  def self.down
        remove_column :movements, :line_id
  end
end
