/ip firewall filter
add chain=Icmp-Chain comment="ICMP chain" action=passthougth
add chain=Icmp-Chain protocol=icmp icmp-options=0:0 action=accept comment="echo reply"
add chain=Icmp-Chain protocol=icmp icmp-options=3:0 action=accept comment="net unreachable"
add chain=Icmp-Chain protocol=icmp icmp-options=3:1 action=accept comment="host unreachable"
add chain=Icmp-Chain protocol=icmp icmp-options=3:4 action=accept comment="host unreachable fragmentation required"
add chain=Icmp-Chain protocol=icmp icmp-options=8:0 action=accept comment="allow echo request"
add chain=Icmp-Chain protocol=icmp icmp-options=11:0 action=accept comment="allow time exceed"
add chain=Icmp-Chain protocol=icmp icmp-options=12:0 action=accept comment="allow parameter bad"
add chain=Icmp-Chain action=jump jump-target=Drop-chain