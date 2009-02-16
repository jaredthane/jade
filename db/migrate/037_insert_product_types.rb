class InsertProductTypes < ActiveRecord::Migration
  def self.up
  	ProductType.create(:name => "Simple")  	
  	ProductType.create(:name => "Combo")  	
  end

  def self.down
  end
end
