class Computer < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn', classes: ['top', 'organizationalPerson', 'person', 'user', 'computer'], prefix: '', scope: :sub

  def nice_name
    sAMAccountName
  end
end
