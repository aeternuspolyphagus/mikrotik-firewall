/ip firewall filter
add chain=drop action=passthrough comment="Main drop chain"
add chain=drop action=drop

/ip firewall raw
add chain=prerouting action=drop src-address-list=protect