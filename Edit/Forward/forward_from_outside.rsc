/ip firewall filter
add chain=Forward-Outside connection-state=established action=accept
add chain=Forward-Outside connection-state=related action=accept
add chain=Forward-Outside connection-state=untracked action=accept
add chain=Forward-Outside connection-state=invalid action=drop
add chain=Forward-Outside connection-nat-state=dstnat action=accept
add chain=Forward-Outside action=jump jump-target=Drop-chain