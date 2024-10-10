/ip firewall filter
add chain=Input-Inside action=passthougth comment="Input chain to router from inside" 
add chain=Input-Inside action=accept connection-state=established 
add chain=Input-Inside action=accept connection-state=related 
add chain=Input-Inside action=accept connection-state=untracked 
add chain=Input-Inside action=jump jump-target=Drop-chain connection-state=invalid
add chain=Input-Inside action=jump jump-target=Input-Inside-All
add chain=Input-Inside action=jump jump-target=Drop-chain