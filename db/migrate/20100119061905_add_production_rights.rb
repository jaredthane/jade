class AddProductionRights < ActiveRecord::Migration
  def self.up
  	r=Right.new(:name=>'Crear Ordenes de Produccion')
  	r.id=88
  	r.save
  	r=Right.new(:name=>'Cambiar Ordenes de Produccion')
  	r.id=89
  	r.save
  	r=Right.new(:name=>'Ver Ordenes de Produccion')
  	r.id=90
  	r.save
  	r=Right.new(:name=>'Borrar Ordenes de Produccion')
  	r.id=91
  	r.save
  	r=Right.new(:name=>'Crear Procesos de Produccion')
  	r.id=92
  	r.save
  	r=Right.new(:name=>'Cambiar Procesos de Produccion')
  	r.id=93
  	r.save
  	r=Right.new(:name=>'Ver Procesos de Produccion')
  	r.id=94
  	r.save
  	r=Right.new(:name=>'Borrar Procesos de Produccion')
  	r.id=95
  	r.save
  	r=Right.new(:name=>'Iniciar Ordenes de Produccion')
  	r.id=96
  	r.save
  	r=Right.new(:name=>'Terminar Ordenes de Produccion')
  	r.id=97
  	r.save
  end

  def self.down
  end
end
