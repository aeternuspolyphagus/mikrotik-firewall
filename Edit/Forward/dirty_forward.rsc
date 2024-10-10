/ip firewall filter
add chain=forward action=passthrough comment="Forward chain"
add chain=forward action=jump jump-target=Protected-chain
add chain=forward in-interface-list=Outside action=jump jump-target=Forward-Outside