# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.

  config.action_controller.session = {
    :session_key => '_Jade_session',
    :secret      => '703ef5219350b6d316dc41ac421cad0afa1018771be92cd0c1c1652a0a929412519c26b1ce18e5d24f947bba7dac106e09da02a3cc45dbf5a8bc11fc0ca3debb'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
	config.active_record.observers = :audit_observer
  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end
require "will_paginate" 
require "prawn"
require "prawn/layout"
require "calendar_date_select"

logfile = File.open('log/audit.log', 'a')   
logfile.sync = true  #remove this for production 
Audit = AuditLogger.new(logfile)
Date::MONTHNAMES = [nil] + %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
Date::DAYNAMES  	=  	%w(Domingo Lunes Martes Miercoles Jueves Viernes Sabado)
Date::ABBR_MONTHNAMES  	=  	[nil] + %w(Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic)
Date::ABBR_DAYNAMES  	=  	%w(Dom Lun Mar Mie Jue Vie Sab)

NEW_SITE_CASH_ACCOUNT_PREFIX = 'Efectivo en '
NEW_SITE_EXPENSE_ACCOUNT_PREFIX ='Gastos en '
NEW_SITE_REVENUE_ACCOUNT_PREFIX = 'Ingresos en '
NEW_SITE_TAX_ACCOUNT_PREFIX = 'Impuestos en '
NEW_SITE_INVENTORY_ACCOUNT_PREFIX = 'Inventario en '
NEW_CLIENT_ACCOUNT_PREFIX=''
NEW_VENDOR_ACCOUNT_PREFIX=''
NEW_EMPLOYEE_ACCOUNT_PREFIX=''
CLIENT_ACCOUNTS_GROUP_PREFIX=''
EMPLOYEE_ACCOUNTS_GROUP_PREFIX=''
VENDOR_ACCOUNTS_GROUP_PREFIX=''

NEW_SITE_CASH_ACCOUNT_SUFFIX = ''
NEW_SITE_EXPENSE_ACCOUNT_SUFFIX=''
NEW_SITE_REVENUE_ACCOUNT_SUFFIX=''
NEW_SITE_TAX_ACCOUNT_SUFFIX=''
NEW_SITE_INVENTORY_ACCOUNT_SUFFIX=''
NEW_CLIENT_ACCOUNT_SUFFIX=''
NEW_VENDOR_ACCOUNT_SUFFIX=''
NEW_EMPLOYEE_ACCOUNT_SUFFIX=''
CLIENT_ACCOUNTS_GROUP_SUFFIX=' Clientes'
EMPLOYEE_ACCOUNTS_GROUP_SUFFIX=' Empleados'
VENDOR_ACCOUNTS_GROUP_SUFFIX=' Proveedores'

NEW_SITE_CASH_ACCOUNT_PARENT_ID=7
NEW_SITE_EXPENSE_ACCOUNT_PARENT_ID=6
NEW_SITE_REVENUE_ACCOUNT_PARENT_ID=5
NEW_SITE_TAX_ACCOUNT_PARENT_ID=12
NEW_SITE_INVENTORY_ACCOUNT_PARENT_ID=8
CLIENT_ACCOUNTS_GROUP_PARENT_ID=15
EMPLOYEE_ACCOUNTS_GROUP_PARENT_ID=13
VENDOR_ACCOUNTS_GROUP_PARENT_ID=14


