/ip firewall filter
add chain=icpm comment="Filter rules for ICMP" action=passthrough
add chain=icmp protocol=icmp icmp-options=0:0 action=accept comment="echo reply" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=3:0 action=accept comment="net unreachable" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=3:1 action=accept comment="host unreachable" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=3:4 action=accept comment="host unreachable fragmentation required" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=8:0 action=accept comment="allow echo request" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=11:0 action=accept comment="allow time exceed" limit=50/5s,2:packet
add chain=icmp protocol=icmp icmp-options=12:0 action=accept comment="allow parameter bad" limit=50/5s,2:packet
add chain=icmp action=jump jump-target=drop comment="all other type jump to drop chain"