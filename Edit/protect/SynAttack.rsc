/ip settings 
set tcp-syncookies=yes

/ip firewall filter
add chain=Detect-SynAttack action=passthrough comment="SynAttack detect chain"
add chain=Detect-SynAttack action=return protocol=tcp tcp-flags=syn,ack dst-limit=32,32,src-and-dst-addresses/10s
add chain=Detect-SynAttack action=add-dst-to-address-list address-list=Banned address-list-timeout=1w3d