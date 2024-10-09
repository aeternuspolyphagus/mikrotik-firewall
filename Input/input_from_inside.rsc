/ip firewall filter
add chain=Input-Inside comment="Input chain to router from inside" action=passthougth
add chain=Input-Inside connection-state=established action=accept
add chain=Input-Inside connection-state=related action=accept
add chain=Input-Inside connection-state=untracked action=accept
add chain=Input-Inside connection-state=invalid action=jump jump-target=Drop-chain