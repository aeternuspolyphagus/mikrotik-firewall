/ip firewall filter
add chain=Protected-chain action=passthougth comment="Protect chain"
add chain=Protected-chain action=jump jump-target=Detect-DDoS connection-state=new
add chain=Protected-chain action=jump jump-target=Detect-SynFlood connection-state=new protocol=tcp tcp-flags=syn
add chain=Protected-chain action=jump jump-target=Detect-SynAttack connection-state=new
add chain=Protected-chain action=jump jump-target=Detect-PortScanners connection-state=new