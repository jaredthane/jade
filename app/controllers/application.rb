# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class AuditLogger < Logger
	def format_message(severity, timestamp, progname, msg)
	  "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
	end 
end 
	
class ApplicationController < ActionController::Base
# Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  before_filter { |c| User.current_user = c.current_user }

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e90656bc2104adcadb40b5ce07b91b4a'
  logfile = File.open('log/audit.log', 'a')   
  logfile.sync = true  #remove this for production 
	audit = AuditLogger.new(logfile) 
	
end
