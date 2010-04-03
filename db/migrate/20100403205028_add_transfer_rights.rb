class AddTransferRights < ActiveRecord::Migration
  def self.up
    Right.create(:name=>"Cambiar Transferencias") { |r| r.id='CHANGE_TRANSFERS'}
    Right.create(:name=>"Crear Transferencias") { |r| r.id='CREATE_TRANSFERS'}
    Right.create(:name=>"Ver Transferencias") { |r| r.id='VIEW_TRANSFERS'}
    Right.create(:name=>"Borrar Transferencias") { |r| r.id='DELETE_TRANSFERS'}
    inventory=Role.find_by_title('Inventario')
    gerente=Role.find_by_title('Gerente')
    admin=Role.find_by_title('Admin')
    RightsRole.create(:role=>admin, :right_id =>'CHANGE_TRANSFERS')
    RightsRole.create(:role=>admin, :right_id =>'CREATE_TRANSFERS')
    RightsRole.create(:role=>admin, :right_id =>'VIEW_TRANSFERS')
    RightsRole.create(:role=>admin, :right_id =>'DELETE_TRANSFERS')
    RightsRole.create(:role=>gerente, :right_id =>'CHANGE_TRANSFERS')
    RightsRole.create(:role=>gerente, :right_id =>'CREATE_TRANSFERS')
    RightsRole.create(:role=>gerente, :right_id =>'VIEW_TRANSFERS')
    RightsRole.create(:role=>gerente, :right_id =>'DELETE_TRANSFERS')
    RightsRole.create(:role=>inventory, :right_id =>'CHANGE_TRANSFERS')
    RightsRole.create(:role=>inventory, :right_id =>'CREATE_TRANSFERS')
    RightsRole.create(:role=>inventory, :right_id =>'VIEW_TRANSFERS')
    RightsRole.create(:role=>inventory, :right_id =>'DELETE_TRANSFERS')
    
    dispatch=Role.create(:title=>'Despacho')
    RightsRole.create(:role=>dispatch, :right_id =>'CHANGE_TRANSFERS')
    RightsRole.create(:role=>dispatch, :right_id =>'CREATE_TRANSFERS')
    RightsRole.create(:role=>dispatch, :right_id =>'VIEW_TRANSFERS')
    RightsRole.create(:role=>dispatch, :right_id =>'DELETE_TRANSFERS')
    RightsRole.create(:role=>dispatch, :right_id =>'VIEW_PRODUCTION_ORDERS')
    RightsRole.create(:role=>dispatch, :right_id =>'FINISH_PRODUCTION_ORDERS')
    RightsRole.create(:role=>dispatch, :right_id =>'VIEW_PRODUCTS')
  end

  def self.down
  end
end
