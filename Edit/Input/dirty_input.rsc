/ip firewall filter
add chain=input comment="Input chain to router" action=passthougth
add chain=input action=jump jump-target=Icmp-Chain
add chain=input action=jump jump-target=Protected-chain
add chain=input in-interface-list=Outside action=jump jump-target=Input-Outside
add chain=input in-interface-list=Inside action=jump jump-target=Input-Inside
add chain=input in-interface-list=!Outside action=jump jump-target=Drop-chain disabled=yes
add chain=input in-interface-list=!Inside action=jump jump-target=Drop-chain disabled=yes