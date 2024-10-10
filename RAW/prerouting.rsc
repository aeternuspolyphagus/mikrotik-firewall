/ip firewall raw
add chain=prerouting action=passthrough comment="Drop from prerouting"
add chain=prerouting action=drop src-address-list=Banned
add chain=prerouting action=drop src-address-list=ddos-attackers dst-address-list=ddos-targets