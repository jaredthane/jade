class Fix < ActiveRecord::Migration
  def self.up
    change_column :entities, :home_phone, :string, :limit => 9
    change_column :entities, :cell_phone, :string, :limit => 9
    change_column :entities, :fax, :string, :limit => 9
    change_column :entities, :nit, :string, :limit => 17
  end

  def self.down
    change_column :entities, :home_phone, :string, :limit => 8
    change_column :entities, :cell_phone, :string, :limit => 8
    change_column :entities, :fax, :string, :limit => 8
    change_column :entities, :nit, :string, :limit => 14
  end
end
