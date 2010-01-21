# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_youtube-popular-riveti-import_session',
  :secret      => '93eb4a0b0b156a5741e9dc890cd066fb165dfe123b26e101f04d1d2c56d9ed1f8dbcef764a72591f7b25b687dd5763af57796be3496d3e218843c58d8606f542'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
