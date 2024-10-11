/ip firewall filter
add chain=Input-Inside-All action=passthrough comment="Input chain from inside to router"
add chain=Input-Inside-All action=accept protocol=udp dst-port=53 
add chain=Input-Inside-All action=accept protocol=tcp dst-port=53
add chain=Input-Inside-All action=accept src-address-list=MNGMNT protocol=tcp dst-port=22
add chain=Input-Inside-All action=accept src-address-list=MNGMNT protocol=tcp dst-port=8291
add chain=Input-Inside-All action=jump jump-target=Drop-chain