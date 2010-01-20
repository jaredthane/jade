class AddProductionRights < ActiveRecord::Migration
	##############################################################
	#
	##############################################################
	def save_if_unique(r)
		Right.find(r.id)
		return r if r
		return Right.new(params)
		Tag.find_or_create_by_name("Summer") # equal to Tag.create(:name => "Summer")
		Right.find_or_create_by_name(r.id)

	end # def find_or_new_by_id(id)
  def self.up
  	r=Right.find_or_create_by_id(:id=>'CREATE_PRODUCTION_ORDERS', :name=>'Crear Ordenes de Produccion') { |r| r.id='CREATE_PRODUCTION_ORDERS'}
  	r=Right.find_or_create_by_id(:id=>'CHANGE_PRODUCTION_ORDERS',:name=>'Cambiar Ordenes de Produccion'){ |r| r.id='CHANGE_PRODUCTION_ORDERS'}
  	r=Right.find_or_create_by_id(:id=>'VIEW_PRODUCTION_ORDERS',:name=>'Ver Ordenes de Produccion'){ |r| r.id='VIEW_PRODUCTION_ORDERS'}
  	r=Right.find_or_create_by_id(:id=>'DELETE_PRODUCTION_ORDERS',:name=>'Borrar Ordenes de Produccion'){ |r| r.id='DELETE_PRODUCTION_ORDERS'}
  	r=Right.find_or_create_by_id(:id=>'CREATE_PRODUCTION_PROCESSES',:name=>'Crear Procesos de Produccion'){ |r| r.id='CREATE_PRODUCTION_PROCESSES'}
  	r=Right.find_or_create_by_id(:id=>'CHANGE_PRODUCTION_PROCESSES',:name=>'Cambiar Procesos de Produccion'){ |r| r.id='CHANGE_PRODUCTION_PROCESSES'}
  	r=Right.find_or_create_by_id(:id=>'VIEW_PRODUCTION_PROCESSES',:name=>'Ver Procesos de Produccion'){ |r| r.id='VIEW_PRODUCTION_PROCESSES'}
  	r=Right.find_or_create_by_id(:id=>'DELETE_PRODUCTION_PROCESSES',:name=>'Borrar Procesos de Produccion'){ |r| r.id='DELETE_PRODUCTION_PROCESSES'}
  	r=Right.find_or_create_by_id(:id=>'START_PRODUCTION_ORDERS',:name=>'Iniciar Ordenes de Produccion'){ |r| r.id='START_PRODUCTION_PROCESSES'}
  	r=Right.find_or_create_by_id(:id=>'FINISH_PRODUCTION_ORDERS',:name=>'Terminar Ordenes de Produccion'){ |r| r.id='FINISH_PRODUCTION_PROCESSES'}
  end

  def self.down
  	Right.find('CREATE_PRODUCTION_ORDERS').destroy
  	Right.find('CHANGE_PRODUCTION_ORDERS').destroy
  	Right.find('VIEW_PRODUCTION_ORDERS').destroy
  	Right.find('DELETE_PRODUCTION_ORDERS').destroy
  	Right.find('CREATE_PRODUCTION_PROCESSES').destroy
  	Right.find('CHANGE_PRODUCTION_PROCESSES').destroy
  	Right.find('VIEW_PRODUCTION_PROCESSES').destroy
  	Right.find('DELETE_PRODUCTION_PROCESSES').destroy
  	Right.find('START_PRODUCTION_ORDERS').destroy
  	Right.find('FINISH_PRODUCTION_ORDERS').destroy
  end
end
