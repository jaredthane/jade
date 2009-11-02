class InsertEntityTypes < ActiveRecord::Migration
  def self.up
  	down
  	EntityType.create(:name => "Proveedor")  	
  	EntityType.create(:name => "Cliente")  	
  	EntityType.create(:name => "Locacion")
  end

  def self.down
  	EntityType.delete_all
  end
end