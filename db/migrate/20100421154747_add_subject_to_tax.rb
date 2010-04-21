class AddSubjectToTax < ActiveRecord::Migration
  def self.up
    add_column :orders, :subject_to_tax, :boolean
  end

  def self.down
    remove_column :orders, :subject_to_tax
  end
end
