class InsertPaymentMethods < ActiveRecord::Migration
  def self.up
  	down
  	PaymentMethod.create(:name => "Efectivo")
  	PaymentMethod.create(:name => "Cheque")
  	PaymentMethod.create(:name => "Tarjeta de Credito")
  	PaymentMethod.create(:name => "Credito")
  end

  def self.down
  	PaymentMethod.delete_all
  end
end
