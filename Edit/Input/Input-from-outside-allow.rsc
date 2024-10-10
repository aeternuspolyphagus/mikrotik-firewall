/ip firewall filter
add chain=Input-Outside-Allow comment="Allow input chain to router from outside" action=passthougth
add chain=Input-Outside-Allow protocol=tcp dst-port=22 connection-nat-state=dstnat action=jump jump-target=BruteForce
add chain=Input-Outside-Allow protocol=tcp dst-port=8291 action=jump jump-target=BruteForce