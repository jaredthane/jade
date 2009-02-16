class InsertEntities < ActiveRecord::Migration
  def self.up
  	down
  	Entity.create(:name => "Anonimo", :entity_type => EntityType.find(2))
  end

  def self.down
  	Entity.delete_all
  end
end
