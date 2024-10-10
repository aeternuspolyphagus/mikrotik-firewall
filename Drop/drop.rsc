/ip firewall filter
add chain=Drop-chain action=passthrough comment="Main drop chain"
add chain=Drop-chain action=drop