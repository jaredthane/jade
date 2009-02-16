class InsertMovementTypes < ActiveRecord::Migration
  def self.up
  	down
  	MovementType.create(:name => "Venta")
  	MovementType.create(:name => "Compra")
  	MovementType.create(:name => "Transferencia")
  	MovementType.create(:name => "Cuenta Fisica")
  	MovementType.create(:name => "Devolucion")
  end

  def self.down
  	MovementType.delete_all
  end
end
