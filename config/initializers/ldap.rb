require 'active_ldap'

LDAP_CONFIG = YAML.load_file(Rails.root.to_s + ('/config/ldap.yml'))[Rails.env]
ActiveLdap::Base.setup_connection LDAP_CONFIG

APP_CONFIG = YAML.load_file(Rails.root.to_s + ('/config/app.yml'))[Rails.env]
