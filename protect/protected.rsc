/ip firewall filter
add chain=Protected-chain comment="Protect chain" action=passthougth

add chain=Protected-chain connection-state=new action=jump jump-target=Detect-DDoS