/ip firewall filter
add chain=Drop-chain action=passthrough comment="Main drop chain"
add chain=Drop-chain action=drop

/ip firewall raw
add chain=prerouting action=passthrough comment="Drop from prerouting"
add chain=prerouting action=drop src-address-list=protect