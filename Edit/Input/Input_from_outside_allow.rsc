/ip firewall filter
add chain=Input-Outside-Allow  action=passthrough comment="Allow input chain to router from outside"
add chain=Input-Outside-Allow  action=jump jump-target=BruteForce protocol=tcp dst-port=22 connection-nat-state=dstnat
add chain=Input-Outside-Allow  action=jump jump-target=BruteForce protocol=tcp dst-port=8291