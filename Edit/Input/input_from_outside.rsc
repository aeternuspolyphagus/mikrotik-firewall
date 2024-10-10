/ip firewall filter
add chain=Input-Outside action=passthougth comment="Input chain to router from outside"
add chain=Input-Outside action=accept connection-state=established
add chain=Input-Outside action=accept connection-state=related
add chain=Input-Outside action=accept connection-state=untracked
add chain=Input-Outside action=jump jump-target=Drop-chain connection-state=invalid
add chain=Input-Outside action=jump jump-target=Input-Outside-Allow
add chain=Input-Outside action=jump jump-target=Drop-chain