/ip firewall filter
add chain=Icmp-Chain action=passthrough comment="ICMP chain" 
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=0:0 comment="echo reply"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:0 comment="net unreachable"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:1 comment="host unreachable"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:4 comment="host unreachable fragmentation required"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=8:0 comment="allow echo request"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=11:0 comment="allow time exceed"
add chain=Icmp-Chain action=accept protocol=icmp icmp-options=12:0 comment="allow parameter bad"
add chain=Icmp-Chain action=jump jump-target=Drop-chain