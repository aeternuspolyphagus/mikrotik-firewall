/ip settings 
set tcp-syncookies=yes

/ip firewall filter
add chain=Detect-SynAttack comment="SynAttack detect chain" action=passthougth
add chain=Detect-SynAttack dst-limit=32,32,src-and-dst-addresses/10s protocol=tcp tcp-flags=syn,ack action=return
add chain=Detect-SynAttack address-list=Banned address-list-timeout=1w3d action=add-dst-to-address-list