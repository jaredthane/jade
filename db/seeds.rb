
MovementType.create(:name=>"Venta"){ |r| r.id=1}
MovementType.create(:name=>"Compra"){ |r| r.id=2}
MovementType.create(:name=>"Transferencia"){ |r| r.id=3}
MovementType.create(:name=>"Cuenta Fisica"){ |r| r.id=4}
MovementType.create(:name=>"Devolucion de Venta"){ |r| r.id=5}
MovementType.create(:name=>"Devolucion de Compra"){ |r| r.id=6}
MovementType.create(:name=>"Devolucion de Transferencia"){ |r| r.id=7}
MovementType.create(:name=>"Consumo Interno"){ |r| r.id=8}
MovementType.create(:name=>"Devolucion de Consumo Interno"){ |r| r.id=9}
MovementType.create(:name=>"Pago"){ |r| r.id=10}
MovementType.create(:name=>"Deposito"){ |r| r.id=11}
MovementType.create(:name=>"Retiro"){ |r| r.id=12}
MovementType.create(:name=>"Pago"){ |r| r.id=13}
MovementType.create(:name=>"Deposito"){ |r| r.id=14}
MovementType.create(:name=>"Retiro"){ |r| r.id=15}
OrderType.create(:name=>"Venta"){ |r| r.id=1}
OrderType.create(:name=>"Compra"){ |r| r.id=2}
OrderType.create(:name=>"Consumo Interno"){ |r| r.id=3}
OrderType.create(:name=>"Transferencia"){ |r| r.id=4}
OrderType.create(:name=>"Cuenta Fisica"){ |r| r.id=5}
OrderType.create(:name=>"Abono a cuenta"){ |r| r.id=6}
OrderType.create(:name=>"Transferencia de Fondos"){ |r| r.id=7}
PaymentMethod.create(:name=>"Efectivo"){ |r| r.id=1}
PaymentMethod.create(:name=>"Cheque"){ |r| r.id=2}
PaymentMethod.create(:name=>"Tarjeta de Credito"){ |r| r.id=3}
PaymentMethod.create(:name=>"Credito"){ |r| r.id=4}
debito=PostType.create(:name=>"Debito"){ |r| r.id=1}
credito=PostType.create(:name=>"Credito"){ |r| r.id=-1}
Preference.create(:name=>"Producto", :value=>1, :pref_group=>"revenue")
Preference.create(:name=>"Categoria", :value=>2, :pref_group=>"revenue")
Preference.create(:name=>"Proveedor", :value=>3, :pref_group=>"revenue")
Preference.create(:name=>"Sitio", :value=>5, :pref_group=>"revenue")
Preference.create(:name=>"Asesor", :value=>4, :pref_group=>"revenue")
Preference.create(:name=>"Usuario", :value=>6, :pref_group=>"revenue")
Preference.create(:name=>"Sitio", :value=>4, :pref_group=>"cash")
Preference.create(:name=>"Asesor", :value=>2, :pref_group=>"cash")
Preference.create(:name=>"Usuario", :value=>3, :pref_group=>"cash")
publico=PriceGroupName.create( :name=>"Publico"){ |r| r.id=1}
mayoreo=PriceGroupName.create( :name=>"Mayoreo"){ |r| r.id=2}
proveedor=EntityType.create( :name=>"Proveedor"){ |r| r.id=1}
consumidor=EntityType.create( :name=>"Consumidor Final"){ |r| r.id=2}
sitio=EntityType.create( :name=>"Sitio"){ |r| r.id=3}
credito_fiscal=EntityType.create( :name=>"Credito Fiscal"){ |r| r.id=5}
empleado=EntityType.create( :name=>"Empleado"){ |r| r.id=6}
banco=EntityType.create( :name=>"Cuenta Bancaria"){ |r| r.id=7}
State.create( :name=>'Ahuachapán'){ |r| r.id=1}
State.create( :name=>'Usulután'){ |r| r.id=14}
State.create( :name=>'Sonsonate'){ |r| r.id=13}
State.create( :name=>'San Vicente'){ |r| r.id=11}
santa_ana=State.create( :name=>'Santa Ana'){ |r| r.id=12}
State.create( :name=>'San Salvador'){ |r| r.id=10}
State.create( :name=>'San Miguel'){ |r| r.id=9}
State.create( :name=>'Morazán'){ |r| r.id=8}
State.create( :name=>'La Unión'){ |r| r.id=7}
State.create( :name=>'La Libertad'){ |r| r.id=5}
State.create( :name=>'La Paz'){ |r| r.id=6}
State.create( :name=>'Cuscatlán'){ |r| r.id=4}
State.create( :name=>'Chalatenango'){ |r| r.id=3}
State.create( :name=>'Cabañas'){ |r| r.id=2}

activos=Account.create( :name=>"Activos", :number=>"1", :modifier=>1, :is_parent=>1){ |r| r.id=2}
pasivos=Account.create( :name=>"Pasivos", :number=>"2", :modifier=>-1, :is_parent=>1){ |r| r.id=3}
Account.create( :name=>"Patrimonio", :number=>"3", :modifier=>-1, :is_parent=>0){ |r| r.id=4}
Account.create( :name=>"Ingresos", :number=>"4", :modifier=>-1, :is_parent=>1){ |r| r.id=5}
Account.create( :name=>"Gastos", :number=>"5", :modifier=>1, :is_parent=>1){ |r| r.id=6}
Account.create( :name=>"Efectivo", :parent=>activos, :number=>"11", :modifier=>1, :is_parent=>1){ |r| r.id=7}
Account.create( :name=>"Inventario", :parent=>activos, :number=>"12", :modifier=>1, :is_parent=>1){ |r| r.id=8}
Account.create( :name=>"Cuenta Bancaria", :parent=>activos, :number=>"13", :modifier=>1, :is_parent=>0){ |r| r.id=9}
cobrar=Account.create( :name=>"Cuentas a Cobrar", :parent=>activos, :number=>"14", :modifier=>1, :is_parent=>1){ |r| r.id=10}
pagar=Account.create( :name=>"Cuentas por Pagar", :parent=>pasivos, :number=>"21", :modifier=>-1, :is_parent=>1){ |r| r.id=11}
Account.create( :name=>"Impuesto", :parent=>pasivos, :number=>"22", :modifier=>-1, :is_parent=>1){ |r| r.id=12}
Account.create( :name=>"Empleados", :parent=>pagar, :number=>"211", :modifier=>-1, :is_parent=>1){ |r| r.id=13}
Account.create( :name=>"Proveedores", :parent=>pagar, :number=>"212", :modifier=>-1, :is_parent=>1){ |r| r.id=14}
Account.create( :name=>"Clientes", :parent=>cobrar, :number=>"141", :modifier=>1, :is_parent=>1){ |r| r.id=15}

home=Entity.create(:id=>5, :name=>'Principal', :entity_type=>sitio, :state=>santa_ana, :active=>1, :price_group_id=> 1, :next_receipt_number=> "1001", :next_bar_code=>"1001"){ |r| r.id=5}
Entity.create(:id=>1, :name=>'Consumo Interno', :entity_type_id=>0, :state=>santa_ana, :active=>1, :site=>home){ |r| r.id=1}
Entity.create(:id=>2, :name=>'Varios', :entity_type=>proveedor, :state=>santa_ana, :active=>1, :site=>home){ |r| r.id=2}
anonimo=Entity.create(:id=>3, :name=>'Anonimo', :entity_type=>consumidor, :price_group_id=>1, :price_group_name=>publico, :site=>home, :state=>santa_ana, :active=>1, :site=>home){ |r| r.id=3}
Entity.create(:id=>4, :name=>'No Specificado', :entity_type=>proveedor, :state=>santa_ana, :active=>1, :site=>home){ |r| r.id=4}
Entity.create(:id=>9, :name=>'Anulado', :entity_type=>consumidor, :state=>santa_ana, :active=>1, :site=>home){ |r| r.id=9}
jade=User.new(:id=>1, :name=>'Sistema Jade', :login=>'Sistema Jade', :location=> home, :price_group_name=>PriceGroupName.first, :do_accounting=>1){ |r| r.id=1}
jade.save_with_validation(perform_validation = false) 
User.current_user=jade
administrator=User.create(:id=>2, :name=>'Administrador', :login=>'admin', :password=>"admin", :password_confirmation=>"admin", :location=> home, :price_group_name=>PriceGroupName.first, :do_accounting=>1){ |r| r.id=2}
anonimo.cash_account.number="14101"
anonimo.cash_account.id=1
anonimo.cash_account.save

ProductType.create(:name=>"Simple"){ |r| r.id=1}
ProductType.create(:name=>"Discount"){ |r| r.id=2}
ProductType.create(:name=>"Combo"){ |r| r.id=3}
ProductType.create(:name=>"Service"){ |r| r.id=4}
Right.create(:name=>"Crear Pagos para Ventas") { |r| r.id='CREATE_PAYMENTS_FOR_SALES'}
Right.create(:name=>"Cambiar Pagos para Ventas") { |r| r.id='CHANGE_PAYMENTS_FOR_SALES'}
Right.create(:name=>"Ver Pagos para Ventas") { |r| r.id='VIEW_PAYMENTS_FOR_SALES'}
Right.create(:name=>"Borrar Pagos para Ventas") { |r| r.id='DELETE_PAYMENTS_FOR_SALES'}
Right.create(:name=>"Crear Pagos para Compras") { |r| r.id='CREATE_PAYMENTS_FOR_PURCHASES'}
Right.create(:name=>"Cambiar Pagos para Compras") { |r| r.id='CHANGE_PAYMENTS_FOR_PURCHASES'}
Right.create(:name=>"Ver Pagos para Compras") { |r| r.id='VIEW_PAYMENTS_FOR_PURCHASES'}
Right.create(:name=>"Borrar Pagos para Compras") { |r| r.id='DELETE_PAYMENTS_FOR_PURCHASES'}
Right.create(:name=>"Crear Ventas") { |r| r.id='CREATE_SALES'}
Right.create(:name=>"Cambiar Ventas") { |r| r.id='CHANGE_SALES'}
Right.create(:name=>"Ver Ventas") { |r| r.id='VIEW_SALES'}
Right.create(:name=>"Borrar Ventas") { |r| r.id='DELETE_SALES'}
Right.create(:name=>"Crear Compras") { |r| r.id='CREATE_PURCHASES'}
Right.create(:name=>"Cambiar Compras") { |r| r.id='CHANGE_PURCHASES'}
Right.create(:name=>"Ver Compras") { |r| r.id='VIEW_PURCHASES'}
Right.create(:name=>"Borrar Compras") { |r| r.id='DELETE_PURCHASES'}
Right.create(:name=>"Crear Clientes") { |r| r.id='CREATE_CLIENTS'}
Right.create(:name=>"Cambiar Clientes") { |r| r.id='CHANGE_CLIENTS'}
Right.create(:name=>"Ver Clientes") { |r| r.id='VIEW_CLIENTS'}
Right.create(:name=>"Borrar Clientes") { |r| r.id='DELETE_CLIENTS'}
Right.create(:name=>"Crear Productos") { |r| r.id='CREATE_PRODUCTS'}
Right.create(:name=>"Cambiar Productos") { |r| r.id='CHANGE_PRODUCTS'}
Right.create(:name=>"Ver Productos") { |r| r.id='VIEW_PRODUCTS'}
Right.create(:name=>"Borrar Productos") { |r| r.id='DELETE_PRODUCTS'}
Right.create(:name=>"Crear Suscripciones") { |r| r.id='CREATE_SUBSCRIPTIONS'}
Right.create(:name=>"Cambiar Suscripciones") { |r| r.id='CHANGE_SUBSCRIPTIONS'}
Right.create(:name=>"Ver Suscripciones") { |r| r.id='VIEW_SUBSCRIPTIONS'}
Right.create(:name=>"Borrar Suscripciones") { |r| r.id='DELETE_SUBSCRIPTIONS'}
Right.create(:name=>"Crear Papeles") { |r| r.id='CREATE_ROLES'}
Right.create(:name=>"Cambiar Papeles") { |r| r.id='CHANGE_ROLES'}
Right.create(:name=>"Ver Papeles") { |r| r.id='VIEW_ROLES'}
Right.create(:name=>"Borrar Papeles") { |r| r.id='DELETE_ROLES'}
Right.create(:name=>"Crear Usuarios") { |r| r.id='CREATE_USERS'}
Right.create(:name=>"Cambiar Usuarios") { |r| r.id='CHANGE_USERS'}
Right.create(:name=>"Ver Usuarios") { |r| r.id='VIEW_USERS'}
Right.create(:name=>"Borrar Usuarios") { |r| r.id='DELETE_USERS'}
Right.create(:name=>"Crear Sitios") { |r| r.id='CREATE_SITES'}
Right.create(:name=>"Cambiar Sitios") { |r| r.id='CHANGE_SITES'}
Right.create(:name=>"Ver Sitios") { |r| r.id='VIEW_SITES'}
Right.create(:name=>"Borrar Sitios") { |r| r.id='DELETE_SITES'}
Right.create(:name=>"Crear Cuentas Fisicas") { |r| r.id='CREATE_COUNTS'}
Right.create(:name=>"Cambiar Cuentas Fisicas") { |r| r.id='CHANGE_COUNTS'}
Right.create(:name=>"Ver Cuentas Fisicas") { |r| r.id='VIEW_COUNTS'}
Right.create(:name=>"Borrar Cuentas Fisicas") { |r| r.id='DELETE_COUNTS'}
Right.create(:name=>"Ver Costos") { |r| r.id='VIEW_COSTS'}
Right.create(:name=>"Crear Cuentas") { |r| r.id='CREATE_ACCOUNTS'}
Right.create(:name=>"Cambiar Cuentas") { |r| r.id='CHANGE_ACCOUNTS'}
Right.create(:name=>"Ver Cuentas") { |r| r.id='VIEW_ACCOUNTS'}
Right.create(:name=>"Borrar Cuentas") { |r| r.id='DELETE_ACCOUNTS'}
Right.create(:name=>"Crear Servicios") { |r| r.id='CREATE_SERVICES'}
Right.create(:name=>"Cambiar Servicios") { |r| r.id='CHANGE_SERVICES'}
Right.create(:name=>"Ver Servicios") { |r| r.id='VIEW_SERVICES'}
Right.create(:name=>"Borrar Servicios") { |r| r.id='DELETE_SERVICES'}
Right.create(:name=>"Crear Combos") { |r| r.id='CREATE_COMBOS'}
Right.create(:name=>"Cambiar Combos") { |r| r.id='CHANGE_COMBOS'}
Right.create(:name=>"Ver Combos") { |r| r.id='VIEW_COMBOS'}
Right.create(:name=>"Borrar Combos") { |r| r.id='DELETE_COMBOS'}
Right.create(:name=>"Crear Descuentos") { |r| r.id='CREATE_DISCOUNTS'}
Right.create(:name=>"Cambiar Descuentos") { |r| r.id='CHANGE_DISCOUNTS'}
Right.create(:name=>"Ver Descuentos") { |r| r.id='VIEW_DISCOUNTS'}
Right.create(:name=>"Borrar Descuentos") { |r| r.id='DELETE_DISCOUNTS'}
Right.create(:name=>"Crear Garantias") { |r| r.id='CREATE_WARRANTIES'}
Right.create(:name=>"Cambiar Garantias") { |r| r.id='CHANGE_WARRANTIES'}
Right.create(:name=>"Ver Garantias") { |r| r.id='VIEW_WARRANTIES'}
Right.create(:name=>"Borrar Garantias") { |r| r.id='DELETE_WARRANTIES'}
Right.create(:name=>"Crear Consumos Internos") { |r| r.id='CREATE_INTERNAL_CONSUMPTIONS'}
Right.create(:name=>"Cambiar Consumos Internos") { |r| r.id='CHANGE_INTERNAL_CONSUMPTIONS'}
Right.create(:name=>"Ver Consumos Internos") { |r| r.id='VIEW_INTERNAL_CONSUMPTIONS'}
Right.create(:name=>"Borrar Consumos Internos") { |r| r.id='DELETE_INTERNAL_CONSUMPTIONS'}
Right.create(:name=>"Crear Numeros de Serie") { |r| r.id='CREATE_SERIAL_NUMBERS'}
Right.create(:name=>"Cambiar Numeros de Serie") { |r| r.id='CHANGE_SERIAL_NUMBERS'}
Right.create(:name=>"Ver Numeros de Serie") { |r| r.id='VIEW_SERIAL_NUMBERS'}
Right.create(:name=>"Borrar Numeros de Serie") { |r| r.id='DELETE_SERIAL_NUMBERS'}
Right.create(:name=>"Cambiar Prices") { |r| r.id='CHANGE_PRICES'}
Right.create(:name=>"Crear Proveedores") { |r| r.id='CREATE_VENDORS'}
Right.create(:name=>"Cambiar Proveedores") { |r| r.id='CHANGE_VENDORS'}
Right.create(:name=>"Ver Proveedores") { |r| r.id='VIEW_VENDORS'}
Right.create(:name=>"Borrar Proveedores") { |r| r.id='DELETE_VENDORS'}
Right.create(:name=>"Crear Transacciones") { |r| r.id='CREATE_TRANSACTIONS'}
Right.create(:name=>"Cambiar Transacciones") { |r| r.id='CHANGE_TRANSACTIONS'}
Right.create(:name=>"Ver Transacciones") { |r| r.id='VIEW_TRANSACTIONS'}
Right.create(:name=>"Borrar Transacciones") { |r| r.id='DELETE_TRANSACTIONS'}
Right.create(:name=>"Procesar Cuentas Fisicas") { |r| r.id='POST_COUNTS'}
Right.create(:name=>"Crear Ordenes de Produccion") { |r| r.id='CREATE_PRODUCTION_ORDERS'}
Right.create(:name=>"Cambiar Ordenes de Produccion") { |r| r.id='CHANGE_PRODUCTION_ORDERS'}
Right.create(:name=>"Ver Ordenes de Produccion") { |r| r.id='VIEW_PRODUCTION_ORDERS'}
Right.create(:name=>"Borrar Ordenes de Produccion") { |r| r.id='DELETE_PRODUCTION_ORDERS'}
Right.create(:name=>"Crear Procesos de Produccion") { |r| r.id='CREATE_PRODUCTION_PROCESSES'}
Right.create(:name=>"Cambiar Procesos de Produccion") { |r| r.id='CHANGE_PRODUCTION_PROCESSES'}
Right.create(:name=>"Ver Procesos de Produccion") { |r| r.id='VIEW_PRODUCTION_PROCESSES'}
Right.create(:name=>"Borrar Procesos de Produccion") { |r| r.id='DELETE_PRODUCTION_PROCESSES'}
Right.create(:name=>"Iniciar Ordenes de Produccion") { |r| r.id='START_PRODUCTION_ORDERS'}
Right.create(:name=>"Terminar Ordenes de Produccion") { |r| r.id='FINISH_PRODUCTION_ORDERS'}
Right.create(:name=>"Hacer Etiquetas") { |r| r.id='CREATE_LABELS'}
Right.create(:name=>"Borrar Etiquetas") { |r| r.id='DELETE_LABELS'}
Right.create(:name=>"Ver Etiquetas") { |r| r.id='VIEW_LABELS'}
Right.create(:name=>"Cambiar Etiquetas") { |r| r.id='CHANGE_LABELS'}

cobrador=Role.create(:title=>'Cobrador')
vendedor=Role.create(:title=>'Vendedor')
comprador=Role.create(:title=>'Comprador')
accountant=Role.create(:title=>'Contabilidad')
inventory=Role.create(:title=>'Inventario')
gerente=Role.create(:title=>'Gerente')
admin=Role.create(:title=>'Admin')
versubs=Role.create(:title=>'Ver Suscripciones')
cambiarsubs=Role.create(:title=>'Cambiar Suscripciones')
oldadmin=Role.create(:title=>'admin')
process_creator=Role.create(:title=>'Planificador de Produccion')
production_starter=Role.create(:title=>'Iniciador de Produccion')
production_finisher=Role.create(:title=>'Terminador de Produccion')
production_viewer=Role.create(:title=>'Ver Produccion')
production_admin=Role.create(:title=>'Administrar Produccion')

RolesUser.create(:user=>administrator,:role=>accountant)
RolesUser.create(:user=>administrator,:role=>admin)
RolesUser.create(:user=>administrator,:role=>versubs)
RolesUser.create(:user=>administrator,:role=>oldadmin)
RolesUser.create(:user=>administrator,:role=>production_admin)


RightsRole.create(:role=>cobrador, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>accountant, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SITES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SITES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SITES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_USERS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_USERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_USERS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_USERS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_ROLES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>versubs, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SALES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PRICES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PRICES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_VENDORS')
RightsRole.create(:role=>process_creator, :right_id =>'CREATE_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'CHANGE_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'CREATE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>process_creator, :right_id =>'CHANGE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>process_creator, :right_id =>'VIEW_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_starter, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_starter, :right_id =>'START_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_finisher, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_finisher, :right_id =>'FINISH_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CREATE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CHANGE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'DELETE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CREATE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'CHANGE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'VIEW_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'DELETE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'START_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'FINISH_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_viewer, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>cobrador, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>cobrador, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>accountant, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>accountant, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>inventory, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_DISCOUNTS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_COMBOS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SERVICES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_ACCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COSTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_COUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SITES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SITES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SITES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SITES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_USERS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_USERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_USERS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_USERS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_ROLES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_ROLES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PRODUCTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_CLIENTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PURCHASES')
RightsRole.create(:role=>versubs, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'CREATE_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'CHANGE_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'VIEW_SUBSCRIPTIONS')
RightsRole.create(:role=>cambiarsubs, :right_id =>'DELETE_SUBSCRIPTIONS')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SALES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SALES')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>accountant, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SALES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SALES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>vendedor, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>inventory, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PAYMENTS_FOR_PURCHASES')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_PRICES')
RightsRole.create(:role=>comprador, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>comprador, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>comprador, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>gerente, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_PAYMENTS_FOR_SALES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_DISCOUNTS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'VIEW_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'DELETE_WARRANTIES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_INTERNAL_CONSUMPTIONS')
RightsRole.create(:role=>admin, :right_id =>'CREATE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_SERIAL_NUMBERS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_PRICES')
RightsRole.create(:role=>admin, :right_id =>'CREATE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'CHANGE_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'VIEW_VENDORS')
RightsRole.create(:role=>admin, :right_id =>'DELETE_VENDORS')
RightsRole.create(:role=>process_creator, :right_id =>'CREATE_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'CHANGE_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>process_creator, :right_id =>'CREATE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>process_creator, :right_id =>'CHANGE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>process_creator, :right_id =>'VIEW_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_starter, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_starter, :right_id =>'START_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_finisher, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_finisher, :right_id =>'FINISH_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CREATE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CHANGE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'VIEW_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'DELETE_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'CREATE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'CHANGE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'VIEW_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'DELETE_PRODUCTION_PROCESSES')
RightsRole.create(:role=>production_admin, :right_id =>'START_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_admin, :right_id =>'FINISH_PRODUCTION_ORDERS')
RightsRole.create(:role=>production_viewer, :right_id =>'VIEW_PRODUCTION_ORDERS')

Unit.create(:name=>'Cada Uno')
Unit.create(:name=>'Hora')
Unit.create(:name=>'Caja')
Unit.create(:name=>'Dolares')
Unit.create(:name=>'Mes')
Unit.create(:name=>'Libra')
Unit.create(:name=>'Galones')


