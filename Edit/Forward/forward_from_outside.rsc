/ip firewall filter
add chain=Forward-Outside action=passthrough comment="Forward chain from outside to inside"
add chain=Forward-Outside connection-nat-state=dstnat action=accept
add chain=Forward-Outside action=jump jump-target=Drop-chain