
ooooo=MovementType.new(:id=>1, :name=>"Venta")
ooooo.id=1
ooooo.save
ooooo=MovementType.new(:id=>2, :name=>"Compra")
ooooo.id=2
ooooo.save
ooooo=MovementType.new(:id=>3, :name=>"Transferencia")
ooooo.id=3
ooooo.save
ooooo=MovementType.new(:id=>4, :name=>"Cuenta Fisica")
ooooo.id=4
ooooo.save
ooooo=MovementType.new(:id=>5, :name=>"Devolucion de Venta")
ooooo.id=5
ooooo.save
ooooo=MovementType.new(:id=>6, :name=>"Devolucion de Compra")
ooooo.id=6
ooooo.save
ooooo=MovementType.new(:id=>7, :name=>"Devolucion de Transferencia")
ooooo.id=7
ooooo.save
ooooo=MovementType.new(:id=>8, :name=>"Consumo Interno")
ooooo.id=8
ooooo.save
ooooo=MovementType.new(:id=>9, :name=>"Devolucion de Consumo Interno")
ooooo.id=9
ooooo.save
ooooo=MovementType.new(:id=>10, :name=>"Pago")
ooooo.id=10
ooooo.save
ooooo=MovementType.new(:id=>11, :name=>"Deposito")
ooooo.id=11
ooooo.save
ooooo=MovementType.new(:id=>12, :name=>"Retiro")
ooooo.id=12
ooooo.save
ooooo=MovementType.new(:id=>13, :name=>"Pago")
ooooo.id=13
ooooo.save
ooooo=MovementType.new(:id=>14, :name=>"Deposito")
ooooo.id=14
ooooo.save
ooooo=MovementType.new(:id=>15, :name=>"Retiro")
ooooo.id=15
ooooo.save
ooooo=OrderType.new(:id=>1, :name=>"Venta")
ooooo.id=1
ooooo.save
ooooo=OrderType.new(:id=>2, :name=>"Compra")
ooooo.id=2
ooooo.save
ooooo=OrderType.new(:id=>3, :name=>"Consumo Interno")
ooooo.id=3
ooooo.save
ooooo=OrderType.new(:id=>4, :name=>"Transferencia")
ooooo.id=4
ooooo.save
ooooo=OrderType.new(:id=>5, :name=>"Cuenta Fisica")
ooooo.id=5
ooooo.save
ooooo=OrderType.new(:id=>6, :name=>"Abono a cuenta")
ooooo.id=6
ooooo.save
ooooo=OrderType.new(:id=>7, :name=>"Transferencia de Fondos")
ooooo.id=7
ooooo.save
ooooo=PaymentMethod.new(:id=>1, :name=>"Efectivo")
ooooo.id=1
ooooo.save
ooooo=PaymentMethod.new(:id=>2, :name=>"Cheque")
ooooo.id=2
ooooo.save
ooooo=PaymentMethod.new(:id=>3, :name=>"Tarjeta de Credito")
ooooo.id=3
ooooo.save
ooooo=PaymentMethod.new(:id=>4, :name=>"Credito")
ooooo.id=4
ooooo.save
debito=PostType.new(:id=>1, :name=>"Debito")
debito.id=1
debito.save
credito=PostType.new(:id=>-1, :name=>"Credito")
credito.id=-1
credito.save
ooooo=Preference.new(:id=>1, :name=>"Producto", :value=>1, :pref_group=>"revenue")
ooooo.id=1
ooooo.save
ooooo=Preference.new(:id=>2, :name=>"Categoria", :value=>2, :pref_group=>"revenue")
ooooo.id=2
ooooo.save
ooooo=Preference.new(:id=>3, :name=>"Proveedor", :value=>3, :pref_group=>"revenue")
ooooo.id=3
ooooo.save
ooooo=Preference.new(:id=>4, :name=>"Sitio", :value=>5, :pref_group=>"revenue")
ooooo.id=4
ooooo.save
ooooo=Preference.new(:id=>5, :name=>"Asesor", :value=>4, :pref_group=>"revenue")
ooooo.id=5
ooooo.save
ooooo=Preference.new(:id=>6, :name=>"Usuario", :value=>6, :pref_group=>"revenue")
ooooo.id=6
ooooo.save
ooooo=Preference.new(:id=>7, :name=>"Sitio", :value=>4, :pref_group=>"cash")
ooooo.id=7
ooooo.save
ooooo=Preference.new(:id=>8, :name=>"Asesor", :value=>2, :pref_group=>"cash")
ooooo.id=8
ooooo.save
ooooo=Preference.new(:id=>9, :name=>"Usuario", :value=>3, :pref_group=>"cash")
ooooo.id=9
ooooo.save
publico=PriceGroupName.new(:id=>1, :name=>"Publico")
publico.id=1
publico.save
mayoreo=PriceGroupName.new(:id=>2, :name=>"Mayoreo")
mayoreo.id=2
mayoreo.save
proveedor=EntityType.new(:id=>1, :name=>"Proveedor")
proveedor.id=1
proveedor.save
consumidor=EntityType.new(:id=>2, :name=>"Consumidor Final")
consumidor.id=2
consumidor.save
sitio=EntityType.new(:id=>3, :name=>"Sitio")
sitio.id=3
sitio.save
credito_fiscal=EntityType.new(:id=>5, :name=>"Credito Fiscal")
credito_fiscal.id=5
credito_fiscal.save
empleado=EntityType.new(:id=>6, :name=>"Empleado")
empleado.id=6
empleado.save
banco=EntityType.new(:id=>7, :name=>"Cuenta Bancaria")
banco.id=7
banco.save
ooooo=State.new(:id=>1, :name=>'Ahuachapán')
ooooo.id=1
ooooo.save
ooooo=State.new(:id=>14, :name=>'Usulután')
ooooo.id=14
ooooo.save
ooooo=State.new(:id=>13, :name=>'Sonsonate')
ooooo.id=13
ooooo.save
ooooo=State.new(:id=>11, :name=>'San Vicente')
ooooo.id=11
ooooo.save
santa_ana=State.new(:id=>12, :name=>'Santa Ana')
santa_ana.id=12
santa_ana.save
ooooo=State.new(:id=>10, :name=>'San Salvador')
ooooo.id=10
ooooo.save
ooooo=State.new(:id=>9, :name=>'San Miguel')
ooooo.id=9
ooooo.save
ooooo=State.new(:id=>8, :name=>'Morazán')
ooooo.id=8
ooooo.save
ooooo=State.new(:id=>7, :name=>'La Unión')
ooooo.id=7
ooooo.save
ooooo=State.new(:id=>5, :name=>'La Libertad')
ooooo.id=5
ooooo.save
ooooo=State.new(:id=>6, :name=>'La Paz')
ooooo.id=6
ooooo.save
ooooo=State.new(:id=>4, :name=>'Cuscatlán')
ooooo.id=4
ooooo.save
ooooo=State.new(:id=>3, :name=>'Chalatenango')
ooooo.id=3
ooooo.save
ooooo=State.new(:id=>2, :name=>'Cabañas')
ooooo.id=2
ooooo.save
activos=Account.new(:id=>2, :name=>"Activos", :number=>"1", :modifier=>1, :is_parent=>1)
activos.id=2
activos.save
pasivos=Account.new(:id=>3, :name=>"Pasivos", :number=>"2", :modifier=>-1, :is_parent=>1)
pasivos.id=3
pasivos.save
ooooo=Account.new(:id=>4, :name=>"Patrimonio", :number=>"3", :modifier=>-1, :is_parent=>0)
ooooo.id=4
ooooo.save
ooooo=Account.new(:id=>5, :name=>"Ingresos", :number=>"4", :modifier=>-1, :is_parent=>1)
ooooo.id=5
ooooo.save
ooooo=Account.new(:id=>6, :name=>"Gastos", :number=>"5", :modifier=>1, :is_parent=>1)
ooooo.id=6
ooooo.save
ooooo=Account.new(:id=>7, :name=>"Efectivo", :parent=>activos, :number=>"11", :modifier=>1, :is_parent=>1)
ooooo.id=7
ooooo.save
ooooo=Account.new(:id=>8, :name=>"Inventario", :parent=>activos, :number=>"12", :modifier=>1, :is_parent=>1)
ooooo.id=8
ooooo.save
ooooo=Account.new(:id=>9, :name=>"Cuenta Bancaria", :parent=>activos, :number=>"13", :modifier=>1, :is_parent=>0)
ooooo.id=9
ooooo.save
cobrar=Account.new(:id=>10, :name=>"Cuentas a Cobrar", :parent=>activos, :number=>"14", :modifier=>1, :is_parent=>1)
cobrar.id=10
cobrar.save
pagar=Account.new(:id=>11, :name=>"Cuentas por Pagar", :parent=>pasivos, :number=>"21", :modifier=>-1, :is_parent=>1)
pagar.id=11
pagar.save
ooooo=Account.new(:id=>12, :name=>"Impuesto", :parent=>pasivos, :number=>"22", :modifier=>-1, :is_parent=>1)
ooooo.id=12
ooooo.save
ooooo=Account.new(:id=>13, :name=>"Empleados", :parent=>pagar, :number=>"211", :modifier=>-1, :is_parent=>1)
ooooo.id=13
ooooo.save
ooooo=Account.new(:id=>14, :name=>"Proveedores", :parent=>pagar, :number=>"212", :modifier=>-1, :is_parent=>1)
ooooo.id=14
ooooo.save
ooooo=Account.new(:id=>15, :name=>"Clientes", :parent=>cobrar, :number=>"141", :modifier=>1, :is_parent=>1)
ooooo.id=15
ooooo.save

home=Entity.new(:id=>5, :name=>'Principal', :entity_type=>site, :state=>santa_ana, :active=>1, :price_group_id=> 1, :next_receipt_number=> "1001", :next_bar_code=>"1001")
home.id=5
home.save
ooooo=Entity.new(:id=>1, :name=>'Consumo Interno', :entity_type_id=>0, :state=>santa_ana, :active=>1, :site=>home)
ooooo.id=1
ooooo.save
ooooo=Entity.new(:id=>2, :name=>'Varios', :entity_type=>proveedor, :state=>santa_ana, :active=>1, :site=>home)
ooooo.id=2
ooooo.save
anonimo=Entity.new(:id=>3, :name=>'Anonimo', :entity_type=>consumidor, :price_group_id=>1, :price_group_name=>publico, :site=>home, :state=>santa_ana, :active=>1, :site=>home)
anonimo.id=3
anonimo.save
ooooo=Entity.new(:id=>4, :name=>'No Specificado', :entity_type=>proveedor, :state=>santa_ana, :active=>1, :site=>home)
ooooo.id=4
ooooo.save
ooooo=Entity.new(:id=>9, :name=>'Anulado', :entity_type=>consumidor, :state=>santa_ana, :active=>1, :site=>home)
ooooo.id=9
ooooo.save
ooooo=User.new(:id=>1, :name=>'Sistema Jade', :login=>'Sistema Jade', :location=> home, :price_group_name=>publico, :do_accounting=>1)
ooooo.id=1
ooooo.save
User.current_user=o
ooooo=User.new(:id=>2, :name=>'Administrador', :login=>'admin', :crypted_password=>"be82f10808d1870ce15d4a47fba42173beb748e9", :location=> home, :price_group_name=>publico, :do_accounting=>1)
ooooo.id=2
ooooo.save
ooooo=
anonimo.cash_account.number="14101"
anonimo.cash_account.id=1
anonimo.cash_account.save

ooooo=ProductType.new(:id=>1, :name=>"Simple")
ooooo.id=1
ooooo.save
ooooo=ProductType.new(:id=>2, :name=>"Discount")
ooooo.id=2
ooooo.save
ooooo=ProductType.new(:id=>3, :name=>"Combo")
ooooo.id=3
ooooo.save
ooooo=ProductType.new(:id=>4, :name=>"Service")
ooooo.id=4
ooooo.save
ooooo=Right.new(:id=>1, :name=>"Crear Pagos para Ventas")
ooooo.id=1
ooooo.save
ooooo=Right.new(:id=>2, :name=>"Cambiar Pagos para Ventas")
ooooo.id=2
ooooo.save
ooooo=Right.new(:id=>3, :name=>"Ver Pagos para Ventas")
ooooo.id=3
ooooo.save
ooooo=Right.new(:id=>4, :name=>"Borrar Pagos para Ventas")
ooooo.id=4
ooooo.save
ooooo=Right.new(:id=>5, :name=>"Crear Pagos para Compras")
ooooo.id=5
ooooo.save
ooooo=Right.new(:id=>6, :name=>"Cambiar Pagos para Compras")
ooooo.id=6
ooooo.save
ooooo=Right.new(:id=>7, :name=>"Ver Pagos para Compras")
ooooo.id=7
ooooo.save
ooooo=Right.new(:id=>8, :name=>"Borrar Pagos para Compras")
ooooo.id=8
ooooo.save
ooooo=Right.new(:id=>9, :name=>"Crear Ventas")
ooooo.id=9
ooooo.save
ooooo=Right.new(:id=>10, :name=>"Cambiar Ventas")
ooooo.id=10
ooooo.save
ooooo=Right.new(:id=>11, :name=>"Ver Ventas")
ooooo.id=11
ooooo.save
ooooo=Right.new(:id=>12, :name=>"Borrar Ventas")
ooooo.id=12
ooooo.save
ooooo=Right.new(:id=>13, :name=>"Crear Compras")
ooooo.id=13
ooooo.save
ooooo=Right.new(:id=>14, :name=>"Cambiar Compras")
ooooo.id=14
ooooo.save
ooooo=Right.new(:id=>15, :name=>"Ver Compras")
ooooo.id=15
ooooo.save
ooooo=Right.new(:id=>16, :name=>"Borrar Compras")
ooooo.id=16
ooooo.save
ooooo=Right.new(:id=>17, :name=>"Crear Consumidor Final")
ooooo.id=17
ooooo.save
ooooo=Right.new(:id=>18, :name=>"Cambiar Consumidor Final")
ooooo.id=18
ooooo.save
ooooo=Right.new(:id=>19, :name=>"Ver Consumidor Final")
ooooo.id=19
ooooo.save
ooooo=Right.new(:id=>20, :name=>"Borrar Consumidor Final")
ooooo.id=20
ooooo.save
ooooo=Right.new(:id=>21, :name=>"Crear Credito Fiscal")
ooooo.id=21
ooooo.save
ooooo=Right.new(:id=>22, :name=>"Cambiar Credito Fiscal")
ooooo.id=22
ooooo.save
ooooo=Right.new(:id=>23, :name=>"Ver Credito Fiscal")
ooooo.id=23
ooooo.save
ooooo=Right.new(:id=>24, :name=>"Borrar Credito Fiscal")
ooooo.id=24
ooooo.save
ooooo=Right.new(:id=>25, :name=>"Crear Productos")
ooooo.id=25
ooooo.save
ooooo=Right.new(:id=>26, :name=>"Cambiar Productos")
ooooo.id=26
ooooo.save
ooooo=Right.new(:id=>27, :name=>"Ver Productos")
ooooo.id=27
ooooo.save
ooooo=Right.new(:id=>28, :name=>"Borrar Productos")
ooooo.id=28
ooooo.save
ooooo=Right.new(:id=>29, :name=>"Crear Suscripciones")
ooooo.id=29
ooooo.save
ooooo=Right.new(:id=>30, :name=>"Cambiar Suscripciones")
ooooo.id=30
ooooo.save
ooooo=Right.new(:id=>31, :name=>"Ver Suscripciones")
ooooo.id=31
ooooo.save
ooooo=Right.new(:id=>32, :name=>"Borrar Suscripciones")
ooooo.id=32
ooooo.save
ooooo=Right.new(:id=>33, :name=>"Crear Papeles")
ooooo.id=33
ooooo.save
ooooo=Right.new(:id=>34, :name=>"Cambiar Papeles")
ooooo.id=34
ooooo.save
ooooo=Right.new(:id=>35, :name=>"Ver Papeles")
ooooo.id=35
ooooo.save
ooooo=Right.new(:id=>36, :name=>"Borrar Papeles")
ooooo.id=36
ooooo.save
ooooo=Right.new(:id=>37, :name=>"Crear Usuarios")
ooooo.id=37
ooooo.save
ooooo=Right.new(:id=>38, :name=>"Cambiar Usuarios")
ooooo.id=38
ooooo.save
ooooo=Right.new(:id=>39, :name=>"Ver Usuarios")
ooooo.id=39
ooooo.save
ooooo=Right.new(:id=>40, :name=>"Borrar Usuarios")
ooooo.id=40
ooooo.save
ooooo=Right.new(:id=>41, :name=>"Crear Sitios")
ooooo.id=41
ooooo.save
ooooo=Right.new(:id=>42, :name=>"Cambiar Sitios")
ooooo.id=42
ooooo.save
ooooo=Right.new(:id=>43, :name=>"Ver Sitios")
ooooo.id=43
ooooo.save
ooooo=Right.new(:id=>44, :name=>"Borrar Sitios")
ooooo.id=44
ooooo.save
ooooo=Right.new(:id=>45, :name=>"Crear Cuentas Fisicas")
ooooo.id=45
ooooo.save
ooooo=Right.new(:id=>46, :name=>"Cambiar Cuentas Fisicas")
ooooo.id=46
ooooo.save
ooooo=Right.new(:id=>47, :name=>"Ver Cuentas Fisicas")
ooooo.id=47
ooooo.save
ooooo=Right.new(:id=>48, :name=>"Borrar Cuentas Fisicas")
ooooo.id=48
ooooo.save
ooooo=Right.new(:id=>49, :name=>"Ver COSTS")
ooooo.id=49
ooooo.save
ooooo=Right.new(:id=>50, :name=>"Crear Cuentas")
ooooo.id=50
ooooo.save
ooooo=Right.new(:id=>51, :name=>"Cambiar Cuentas")
ooooo.id=51
ooooo.save
ooooo=Right.new(:id=>52, :name=>"Ver Cuentas")
ooooo.id=52
ooooo.save
ooooo=Right.new(:id=>53, :name=>"Borrar Cuentas")
ooooo.id=53
ooooo.save
ooooo=Right.new(:id=>54, :name=>"Crear Servicios")
ooooo.id=54
ooooo.save
ooooo=Right.new(:id=>55, :name=>"Cambiar Servicios")
ooooo.id=55
ooooo.save
ooooo=Right.new(:id=>56, :name=>"Ver Servicios")
ooooo.id=56
ooooo.save
ooooo=Right.new(:id=>57, :name=>"Borrar Servicios")
ooooo.id=57
ooooo.save
ooooo=Right.new(:id=>58, :name=>"Crear Combos")
ooooo.id=58
ooooo.save
ooooo=Right.new(:id=>59, :name=>"Cambiar Combos")
ooooo.id=59
ooooo.save
ooooo=Right.new(:id=>60, :name=>"Ver Combos")
ooooo.id=60
ooooo.save
ooooo=Right.new(:id=>61, :name=>"Borrar Combos")
ooooo.id=61
ooooo.save
ooooo=Right.new(:id=>62, :name=>"Crear Descuentos")
ooooo.id=62
ooooo.save
ooooo=Right.new(:id=>63, :name=>"Cambiar Descuentos")
ooooo.id=63
ooooo.save
ooooo=Right.new(:id=>64, :name=>"Ver Descuentos")
ooooo.id=64
ooooo.save
ooooo=Right.new(:id=>65, :name=>"Borrar Descuentos")
ooooo.id=65
ooooo.save
ooooo=Right.new(:id=>66, :name=>"Crear Garantias")
ooooo.id=66
ooooo.save
ooooo=Right.new(:id=>67, :name=>"Cambiar Garantias")
ooooo.id=67
ooooo.save
ooooo=Right.new(:id=>68, :name=>"Ver Garantias")
ooooo.id=68
ooooo.save
ooooo=Right.new(:id=>69, :name=>"Borrar Garantias")
ooooo.id=69
ooooo.save
ooooo=Right.new(:id=>70, :name=>"Crear Consumos Internos")
ooooo.id=70
ooooo.save
ooooo=Right.new(:id=>71, :name=>"Cambiar Consumos Internos")
ooooo.id=71
ooooo.save
ooooo=Right.new(:id=>72, :name=>"Ver Consumos Internos")
ooooo.id=72
ooooo.save
ooooo=Right.new(:id=>73, :name=>"Borrar Consumos Internos")
ooooo.id=73
ooooo.save
ooooo=Right.new(:id=>74, :name=>"Crear Numeros de Serie")
ooooo.id=74
ooooo.save
ooooo=Right.new(:id=>75, :name=>"Cambiar Numeros de Serie")
ooooo.id=75
ooooo.save
ooooo=Right.new(:id=>76, :name=>"Ver Numeros de Serie")
ooooo.id=76
ooooo.save
ooooo=Right.new(:id=>77, :name=>"Borrar Numeros de Serie")
ooooo.id=77
ooooo.save
ooooo=Right.new(:id=>78, :name=>"Cambiar Prices")
ooooo.id=78
ooooo.save
ooooo=Right.new(:id=>79, :name=>"Crear Proveedores")
ooooo.id=79
ooooo.save
ooooo=Right.new(:id=>80, :name=>"Cambiar Proveedores")
ooooo.id=80
ooooo.save
ooooo=Right.new(:id=>81, :name=>"Ver Proveedores")
ooooo.id=81
ooooo.save
ooooo=Right.new(:id=>82, :name=>"Borrar Proveedores")
ooooo.id=82
ooooo.save
ooooo=Right.new(:id=>83, :name=>"Crear Transacciones")
ooooo.id=83
ooooo.save
ooooo=Right.new(:id=>84, :name=>"Cambiar Transacciones")
ooooo.id=84
ooooo.save
ooooo=Right.new(:id=>85, :name=>"Ver Transacciones")
ooooo.id=85
ooooo.save
ooooo=Right.new(:id=>86, :name=>"Borrar Transacciones")
ooooo.id=86
ooooo.save
ooooo=Right.new(:id=>87, :name=>"Procesar Cuentas Fisicas")
ooooo.id=87
ooooo.save
ooooo=Right.new(:id=>88, :name=>"Crear Ordenes de Produccion")
ooooo.id=88
ooooo.save
ooooo=Right.new(:id=>89, :name=>"Cambiar Ordenes de Produccion")
ooooo.id=89
ooooo.save
ooooo=Right.new(:id=>90, :name=>"Ver Ordenes de Produccion")
ooooo.id=90
ooooo.save
ooooo=Right.new(:id=>91, :name=>"Borrar Ordenes de Produccion")
ooooo.id=91
ooooo.save
ooooo=Right.new(:id=>92, :name=>"Crear Procesos de Produccion")
ooooo.id=92
ooooo.save
ooooo=Right.new(:id=>93, :name=>"Cambiar Procesos de Produccion")
ooooo.id=93
ooooo.save
ooooo=Right.new(:id=>94, :name=>"Ver Procesos de Produccion")
ooooo.id=94
ooooo.save
ooooo=Right.new(:id=>95, :name=>"Borrar Procesos de Produccion")
ooooo.id=95
ooooo.save
ooooo=Right.new(:id=>96, :name=>"Iniciar Ordenes de Produccion")
ooooo.id=96
ooooo.save
ooooo=Right.new(:id=>97, :name=>"Terminar Ordenes de Produccion")
ooooo.id=97
ooooo.save
jade=User.create(:name=>'Sistema Jade', :login=>'Sistema Jade', :location=>home, :active=>1, :price_group_name=>publico)
admin=User.create(:name=>'Administrador', :login=>'admin', :crypted_password=> '71d52dbae5655e57b802caae4f85c24a2b4acb10', :salt=>'b1547f784045f4e8857bfcffb25fbf47f69c67b6', :location=>home, :active=>1, :price_group_name=>publico)
cobrador=Role.new(:id=>1, :title=>'Cobrador')
vendedor=Role.new(:id=>2, :title=>'Vendedor')
comprador=Role.new(:id=>3, :title=>'Comprador')
accountant=Role.new(:id=>4, :title=>'Contabilidad')
inventory=Role.new(:id=>5, :title=>'Inventario')
gerente=Role.new(:id=>6, :title=>'Gerente')
admin=Role.new(:id=>7, :title=>'Admin')
versubs=Role.new(:id=>8, :title=>'Ver Suscripciones')
cambiarsubs=Role.new(:id=>9, :title=>'Cambiar Suscripciones')
oldadmin=Role.new(:id=>10, :title=>'admin')
RightRole.create(:role=>cobrador, :right_id =>1)
RightRole.create(:role=>cobrador, :right_id =>2)
RightRole.create(:role=>cobrador, :right_id =>3)
RightRole.create(:role=>cobrador, :right_id =>11)
RightRole.create(:role=>cobrador, :right_id =>19)
RightRole.create(:role=>cobrador, :right_id =>23)
RightRole.create(:role=>cobrador, :right_id =>43)
RightRole.create(:role=>cobrador, :right_id =>56)
RightRole.create(:role=>cobrador, :right_id =>60)
RightRole.create(:role=>cobrador, :right_id =>64)
RightRole.create(:role=>vendedor, :right_id =>3)
RightRole.create(:role=>vendedor, :right_id =>9)
RightRole.create(:role=>vendedor, :right_id =>10)
RightRole.create(:role=>vendedor, :right_id =>11)
RightRole.create(:role=>vendedor, :right_id =>17)
RightRole.create(:role=>vendedor, :right_id =>18)
RightRole.create(:role=>vendedor, :right_id =>19)
RightRole.create(:role=>vendedor, :right_id =>21)
RightRole.create(:role=>vendedor, :right_id =>22)
RightRole.create(:role=>vendedor, :right_id =>23)
RightRole.create(:role=>vendedor, :right_id =>27)
RightRole.create(:role=>vendedor, :right_id =>43)
RightRole.create(:role=>vendedor, :right_id =>56)
RightRole.create(:role=>vendedor, :right_id =>60)
RightRole.create(:role=>vendedor, :right_id =>64)
RightRole.create(:role=>comprador, :right_id =>5)
RightRole.create(:role=>comprador, :right_id =>6)
RightRole.create(:role=>comprador, :right_id =>7)
RightRole.create(:role=>comprador, :right_id =>11)
RightRole.create(:role=>comprador, :right_id =>13)
RightRole.create(:role=>comprador, :right_id =>14)
RightRole.create(:role=>comprador, :right_id =>15)
RightRole.create(:role=>comprador, :right_id =>16)
RightRole.create(:role=>comprador, :right_id =>25)
RightRole.create(:role=>comprador, :right_id =>26)
RightRole.create(:role=>comprador, :right_id =>27)
RightRole.create(:role=>comprador, :right_id =>43)
RightRole.create(:role=>comprador, :right_id =>49)
RightRole.create(:role=>comprador, :right_id =>56)
RightRole.create(:role=>comprador, :right_id =>60)
RightRole.create(:role=>comprador, :right_id =>64)
RightRole.create(:role=>accountant, :right_id =>3)
RightRole.create(:role=>accountant, :right_id =>7)
RightRole.create(:role=>accountant, :right_id =>11)
RightRole.create(:role=>accountant, :right_id =>15)
RightRole.create(:role=>accountant, :right_id =>43)
RightRole.create(:role=>accountant, :right_id =>49)
RightRole.create(:role=>accountant, :right_id =>50)
RightRole.create(:role=>accountant, :right_id =>51)
RightRole.create(:role=>accountant, :right_id =>52)
RightRole.create(:role=>accountant, :right_id =>53)
RightRole.create(:role=>inventory, :right_id =>11)
RightRole.create(:role=>inventory, :right_id =>15)
RightRole.create(:role=>inventory, :right_id =>19)
RightRole.create(:role=>inventory, :right_id =>23)
RightRole.create(:role=>inventory, :right_id =>25)
RightRole.create(:role=>inventory, :right_id =>26)
RightRole.create(:role=>inventory, :right_id =>27)
RightRole.create(:role=>inventory, :right_id =>31)
RightRole.create(:role=>inventory, :right_id =>43)
RightRole.create(:role=>inventory, :right_id =>45)
RightRole.create(:role=>inventory, :right_id =>46)
RightRole.create(:role=>inventory, :right_id =>47)
RightRole.create(:role=>inventory, :right_id =>48)
RightRole.create(:role=>inventory, :right_id =>49)
RightRole.create(:role=>inventory, :right_id =>56)
RightRole.create(:role=>inventory, :right_id =>58)
RightRole.create(:role=>inventory, :right_id =>59)
RightRole.create(:role=>inventory, :right_id =>60)
RightRole.create(:role=>inventory, :right_id =>64)
RightRole.create(:role=>gerente, :right_id =>1)
RightRole.create(:role=>gerente, :right_id =>2)
RightRole.create(:role=>gerente, :right_id =>3)
RightRole.create(:role=>gerente, :right_id =>5)
RightRole.create(:role=>gerente, :right_id =>6)
RightRole.create(:role=>gerente, :right_id =>7)
RightRole.create(:role=>gerente, :right_id =>9)
RightRole.create(:role=>gerente, :right_id =>10)
RightRole.create(:role=>gerente, :right_id =>11)
RightRole.create(:role=>gerente, :right_id =>12)
RightRole.create(:role=>gerente, :right_id =>13)
RightRole.create(:role=>gerente, :right_id =>14)
RightRole.create(:role=>gerente, :right_id =>15)
RightRole.create(:role=>gerente, :right_id =>16)
RightRole.create(:role=>gerente, :right_id =>17)
RightRole.create(:role=>gerente, :right_id =>18)
RightRole.create(:role=>gerente, :right_id =>19)
RightRole.create(:role=>gerente, :right_id =>21)
RightRole.create(:role=>gerente, :right_id =>22)
RightRole.create(:role=>gerente, :right_id =>23)
RightRole.create(:role=>gerente, :right_id =>25)
RightRole.create(:role=>gerente, :right_id =>26)
RightRole.create(:role=>gerente, :right_id =>27)
RightRole.create(:role=>gerente, :right_id =>29)
RightRole.create(:role=>gerente, :right_id =>30)
RightRole.create(:role=>gerente, :right_id =>31)
RightRole.create(:role=>gerente, :right_id =>32)
RightRole.create(:role=>gerente, :right_id =>43)
RightRole.create(:role=>gerente, :right_id =>45)
RightRole.create(:role=>gerente, :right_id =>46)
RightRole.create(:role=>gerente, :right_id =>47)
RightRole.create(:role=>gerente, :right_id =>48)
RightRole.create(:role=>gerente, :right_id =>49)
RightRole.create(:role=>gerente, :right_id =>50)
RightRole.create(:role=>gerente, :right_id =>51)
RightRole.create(:role=>gerente, :right_id =>52)
RightRole.create(:role=>gerente, :right_id =>53)
RightRole.create(:role=>gerente, :right_id =>54)
RightRole.create(:role=>gerente, :right_id =>55)
RightRole.create(:role=>gerente, :right_id =>56)
RightRole.create(:role=>gerente, :right_id =>58)
RightRole.create(:role=>gerente, :right_id =>59)
RightRole.create(:role=>gerente, :right_id =>60)
RightRole.create(:role=>gerente, :right_id =>62)
RightRole.create(:role=>gerente, :right_id =>63)
RightRole.create(:role=>gerente, :right_id =>64)
RightRole.create(:role=>admin, :right_id =>62)
RightRole.create(:role=>admin, :right_id =>61)
RightRole.create(:role=>admin, :right_id =>60)
RightRole.create(:role=>admin, :right_id =>59)
RightRole.create(:role=>admin, :right_id =>58)
RightRole.create(:role=>admin, :right_id =>57)
RightRole.create(:role=>admin, :right_id =>56)
RightRole.create(:role=>admin, :right_id =>55)
RightRole.create(:role=>admin, :right_id =>54)
RightRole.create(:role=>admin, :right_id =>53)
RightRole.create(:role=>admin, :right_id =>52)
RightRole.create(:role=>admin, :right_id =>51)
RightRole.create(:role=>admin, :right_id =>50)
RightRole.create(:role=>admin, :right_id =>49)
RightRole.create(:role=>admin, :right_id =>48)
RightRole.create(:role=>admin, :right_id =>47)
RightRole.create(:role=>admin, :right_id =>46)
RightRole.create(:role=>admin, :right_id =>45)
RightRole.create(:role=>admin, :right_id =>44)
RightRole.create(:role=>admin, :right_id =>43)
RightRole.create(:role=>admin, :right_id =>42)
RightRole.create(:role=>admin, :right_id =>41)
RightRole.create(:role=>admin, :right_id =>40)
RightRole.create(:role=>admin, :right_id =>39)
RightRole.create(:role=>admin, :right_id =>38)
RightRole.create(:role=>admin, :right_id =>37)
RightRole.create(:role=>admin, :right_id =>36)
RightRole.create(:role=>admin, :right_id =>35)
RightRole.create(:role=>admin, :right_id =>34)
RightRole.create(:role=>admin, :right_id =>33)
RightRole.create(:role=>admin, :right_id =>32)
RightRole.create(:role=>admin, :right_id =>31)
RightRole.create(:role=>admin, :right_id =>30)
RightRole.create(:role=>admin, :right_id =>29)
RightRole.create(:role=>admin, :right_id =>28)
RightRole.create(:role=>admin, :right_id =>27)
RightRole.create(:role=>admin, :right_id =>26)
RightRole.create(:role=>admin, :right_id =>25)
RightRole.create(:role=>admin, :right_id =>24)
RightRole.create(:role=>admin, :right_id =>23)
RightRole.create(:role=>admin, :right_id =>22)
RightRole.create(:role=>admin, :right_id =>21)
RightRole.create(:role=>admin, :right_id =>20)
RightRole.create(:role=>admin, :right_id =>19)
RightRole.create(:role=>admin, :right_id =>18)
RightRole.create(:role=>admin, :right_id =>17)
RightRole.create(:role=>admin, :right_id =>16)
RightRole.create(:role=>admin, :right_id =>15)
RightRole.create(:role=>versubs, :right_id =>31)
RightRole.create(:role=>cambiarsubs, :right_id =>29)
RightRole.create(:role=>cambiarsubs, :right_id =>30)
RightRole.create(:role=>cambiarsubs, :right_id =>31)
RightRole.create(:role=>cambiarsubs, :right_id =>32)
RightRole.create(:role=>comprador, :right_id =>66)
RightRole.create(:role=>comprador, :right_id =>67)
RightRole.create(:role=>comprador, :right_id =>68)
RightRole.create(:role=>vendedor, :right_id =>68)
RightRole.create(:role=>inventory, :right_id =>68)
RightRole.create(:role=>gerente, :right_id =>68)
RightRole.create(:role=>admin, :right_id =>14)
RightRole.create(:role=>gerente, :right_id =>66)
RightRole.create(:role=>gerente, :right_id =>67)
RightRole.create(:role=>admin, :right_id =>13)
RightRole.create(:role=>admin, :right_id =>12)
RightRole.create(:role=>admin, :right_id =>11)
RightRole.create(:role=>gerente, :right_id =>70)
RightRole.create(:role=>gerente, :right_id =>71)
RightRole.create(:role=>gerente, :right_id =>72)
RightRole.create(:role=>inventory, :right_id =>72)
RightRole.create(:role=>vendedor, :right_id =>72)
RightRole.create(:role=>comprador, :right_id =>72)
RightRole.create(:role=>accountant, :right_id =>72)
RightRole.create(:role=>admin, :right_id =>10)
RightRole.create(:role=>admin, :right_id =>9)
RightRole.create(:role=>admin, :right_id =>8)
RightRole.create(:role=>admin, :right_id =>7)
RightRole.create(:role=>vendedor, :right_id =>76)
RightRole.create(:role=>comprador, :right_id =>76)
RightRole.create(:role=>inventory, :right_id =>76)
RightRole.create(:role=>gerente, :right_id =>76)
RightRole.create(:role=>admin, :right_id =>6)
RightRole.create(:role=>admin, :right_id =>5)
RightRole.create(:role=>gerente, :right_id =>78)
RightRole.create(:role=>comprador, :right_id =>79)
RightRole.create(:role=>comprador, :right_id =>80)
RightRole.create(:role=>comprador, :right_id =>81)
RightRole.create(:role=>gerente, :right_id =>81)
RightRole.create(:role=>gerente, :right_id =>79)
RightRole.create(:role=>gerente, :right_id =>80)
RightRole.create(:role=>admin, :right_id =>4)
RightRole.create(:role=>admin, :right_id =>3)
RightRole.create(:role=>admin, :right_id =>2)
RightRole.create(:role=>admin, :right_id =>1)
RightRole.create(:role=>admin, :right_id =>63)
RightRole.create(:role=>admin, :right_id =>64)
RightRole.create(:role=>admin, :right_id =>65)
RightRole.create(:role=>admin, :right_id =>66)
RightRole.create(:role=>admin, :right_id =>67)
RightRole.create(:role=>admin, :right_id =>68)
RightRole.create(:role=>admin, :right_id =>69)
RightRole.create(:role=>admin, :right_id =>70)
RightRole.create(:role=>admin, :right_id =>71)
RightRole.create(:role=>admin, :right_id =>72)
RightRole.create(:role=>admin, :right_id =>73)
RightRole.create(:role=>admin, :right_id =>74)
RightRole.create(:role=>admin, :right_id =>75)
RightRole.create(:role=>admin, :right_id =>76)
RightRole.create(:role=>admin, :right_id =>77)
RightRole.create(:role=>admin, :right_id =>78)
RightRole.create(:role=>admin, :right_id =>79)
RightRole.create(:role=>admin, :right_id =>80)
RightRole.create(:role=>admin, :right_id =>81)
RightRole.create(:role=>admin, :right_id =>82)



