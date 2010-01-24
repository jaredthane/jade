class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :id
      t.string :value
    end
  end

  def self.down
    drop_table :preferences
  end
end
