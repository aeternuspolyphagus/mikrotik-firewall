/ip firewall filter
add chain=Forward-Outside action=passthrough comment="Forward chain from outside to inside"
add chain=Forward-Outside action=jump jump-target=Drop-chain connection-nat-state=!dstnat connection-state=new
add chain=Forward-Outside action=jump jump-target=Drop-chain in-interface-list=Outside out-interface-list=!Inside src-address-list=not_in_internet
add chain=Forward-Outside connection-nat-state=dstnat action=accept
add chain=Forward-Outside action=jump jump-target=Drop-chain