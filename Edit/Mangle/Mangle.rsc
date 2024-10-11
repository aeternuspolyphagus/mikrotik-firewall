/ip firewall mangle
add action=mark-connection chain=input comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=in,ipsec new-connection-mark=ipsec
add action=mark-connection chain=output comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=out,ipsec new-connection-mark=ipsec 
add action=mark-connection chain=forward comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=out,ipsec new-connection-mark=ipsec 
add action=mark-connection chain=forward comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=in,ipsec new-connection-mark=ipsec