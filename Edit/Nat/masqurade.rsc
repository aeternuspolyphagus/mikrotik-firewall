/ip firewall nat
add chain=srcnat action=accept ipsec-policy=out,ipsec
add chain=dstnat action=accept ipsec-policy=in,ipsec
add chain=srcnat action=masquerade out-interface-list=Outside