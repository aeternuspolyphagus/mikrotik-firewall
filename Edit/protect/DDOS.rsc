/ip firewall filter
add chain=Detect-DDoS comment="DDoS detect chain" action=passthougth
add chain=Detect-DDoS dst-limit=32,32,src-and-dst-addresses/10s action=return
add chain=Detect-DDoS address-list=ddos-targets address-list-timeout=10m action=add-dst-to-address-list
add chain=Detect-DDoS address-list=ddos-attackers address-list-timeout=10m action=add-src-to-address-list
