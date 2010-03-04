class AddNation < ActiveRecord::Migration
  def self.up
    add_column :entities, :country, :string
  end

  def self.down
    remove_column :entities, :country
  end
end
