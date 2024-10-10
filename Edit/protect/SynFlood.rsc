/ip firewall filter
add chain=Detect-SynFlood action=passthougth comment="SynFlood detect chain"
add chain=Detect-SynFlood action=return connection-state=new protocol=tcp tcp-flags=syn limit=200,5:packet
add chain=Detect-SynFlood action=add-dst-to-address-list address-list=Banned address-list-timeout=1w3d