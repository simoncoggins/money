# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_money_session',
  :secret      => '40babafd1b02a17cf02c4dec2e19ed49cf793153f9d07dad93a4db3ee3f369a761cd75b0a8a2722094471e0b6a6192c7cfa1d2ac16d07c1c01bdd431007f7fae'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
