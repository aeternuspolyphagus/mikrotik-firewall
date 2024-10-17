/ip firewall filter
add chain=Detect-DDoS action=passthrough comment="DDoS detect chain" 
add chain=Detect-DDoS action=return dst-limit=32,32,src-and-dst-addresses/10s 
add chain=Detect-DDoS action=add-dst-to-address-list address-list=ddos-targets address-list-timeout=10m 
add chain=Detect-DDoS action=add-src-to-address-list address-list=ddos-attackers address-list-timeout=10m 
