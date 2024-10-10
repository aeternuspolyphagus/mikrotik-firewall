/ip firewall filter
add chain=Detect-Portscanners comment="Port scanner detect chain" action=passthougth
add chain=Detect-Portscanners address-list=Banned protocol=tcp psd=21,3s,3,1 address-list-timeout=none-dynamic action=add-src-to-address-list
