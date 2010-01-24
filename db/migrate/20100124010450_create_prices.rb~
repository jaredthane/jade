class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
		  t.integer :price_set_id
		  t.string :product_id
		  t.decimal :fixed,          :precision => 8, :scale => 2
		  t.decimal :relative,       :precision => 8, :scale => 2
		  t.boolean :available
    end
  end

  def self.down
    drop_table :prices
  end
end
