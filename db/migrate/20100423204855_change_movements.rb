class ChangeMovements < ActiveRecord::Migration
    def self.up
        remove_column :movements, :line_id
        remove_column :movements, :cost_ref
        rename_column :movements, :value_left, :cost_left
    end

    def self.down
        add_column :movements, :line_id, :integer
        add_column :movements, :cost_ref, :integer
        rename_column :movements, :cost_left, :value_left
    end
end
