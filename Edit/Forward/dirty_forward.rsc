/ip firewall filter
add chain=forward action=passthrough comment="Forward chain"
add chain=forward action=fasttrack-connection connection-state=established connection-mark=!ipsec 
add chain=forward action=fasttrack-connection connection-state=related connection-mark=!ipsec 
add chain=forward action=accept connection-state=established
add chain=forward action=accept connection-state=related
add chain=forward action=accept connection-state=untracked
add chain=forward action=jump jump-target=Drop-chain connection-state=invalid
add action=drop chain=forward src-address-list=no_forward_ipv4
add action=drop chain=forward dst-address-list=no_forward_ipv4
add chain=forward action=jump jump-target=Protected-chain
add chain=forward in-interface-list=Outside action=jump jump-target=Forward-Outside
add chain=forward in-interface-list=Inside action=jump jump-target=Forward-Inside