# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jade_session',
  :secret      => 'd0ba15895d1bb7680df0fabcac35d78cc5feb62c803b1672dc6156bca34b3e9a458810aa7460a47f5b69227c018650c06fecdaff56ce17dd6467442e7c3bce31'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
