class Computer < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn', classes: ['top', 'organizationalPerson', 'person', 'user', 'computer'], prefix: '', scope: :sub

  def ping
    pinger = Net::Ping::External.new(dnshostname)
    pinger.ping?
  end

  def nice_name
    sAMAccountName
  end
end
