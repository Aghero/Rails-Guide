# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails-demo_session',
  :secret      => '99c7da9ec6a47cc6c95cde128fbb1abb246285b8d359c1797ee822ad0e296aeb4c0cdb1b567627c19cf3f8c79b85160d8e6390ecb7620bf714574a90574519ca'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
