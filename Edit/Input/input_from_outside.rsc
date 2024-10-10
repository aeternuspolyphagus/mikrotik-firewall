/ip firewall filter
add chain=Input-Outside comment="Input chain to router from outside" action=passthougth
add chain=Input-Outside connection-state=established action=accept
add chain=Input-Outside connection-state=related action=accept
add chain=Input-Outside connection-state=untracked action=accept
add chain=Input-Outside connection-state=invalid action=jump jump-target=Drop-chain
add chain=Input-Outside action=jump jump-target=Input-Outside-Allow
add chain=Input-Outside action=jump jump-target=Drop-chain