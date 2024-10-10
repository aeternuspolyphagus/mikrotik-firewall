/ip firewall filter
add chain=input action=passthrough comment="Input chain to router"
add chain=input action=jump jump-target=Icmp-Chain protocol=icmp
add chain=input action=jump jump-target=Protected-chain
add chain=input action=jump jump-target=Input-Outside in-interface-list=Outside
add chain=input action=jump jump-target=Input-Inside in-interface-list=Inside
add chain=input action=jump jump-target=Drop-chain in-interface-list=!Outside disabled=yes
add chain=input action=jump jump-target=Drop-chain in-interface-list=!Inside disabled=yes
