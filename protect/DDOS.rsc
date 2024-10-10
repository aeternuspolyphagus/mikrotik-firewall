/ip firewall filter
add chain=Detect-DDoS comment="DDoS detect chain" action=passthougth
add chain=Detect-DDoS dst-limit=32,32,src-and-dst-addresses/10s action=return
add action=add-dst-to-address-list address-list=ddos-targets address-list-timeout=10m chain=Detect-DDoS
add action=add-src-to-address-list address-list=ddos-attackers address-list-timeout=10m chain=Detect-DDoS
