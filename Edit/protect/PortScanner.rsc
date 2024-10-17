/ip firewall filter
add chain=Detect-Portscanners action=passthrough comment="Port scanner detect chain" action=passthrough
add chain=Detect-Portscanners action=add-src-to-address-list address-list=Banned address-list-timeout=none-dynamic protocol=tcp psd=21,3s,3,1
