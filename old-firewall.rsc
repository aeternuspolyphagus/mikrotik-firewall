/ip firewall filter
add action=fasttrack-connection chain=forward comment="ALLOW - Established, Related connections" connection-state=established,related hw-offload=yes
add action=accept chain=forward connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=drop chain=forward comment="DROP - Invalid connections" connection-state=invalid
add action=drop chain=input connection-state=invalid
add action=jump chain=input comment="DDoS - SYN flood protection" connection-state=new in-interface-list=ISP jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect limit=200,5:packet tcp-flags=""
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=SYN-Protect log-prefix="DDoS: SYN-Protect" tcp-flags=""
add action=jump chain=input comment="DDoS - Main protection" connection-state=new in-interface-list=ISP jump-target=DDoS-Protect
add action=return chain=DDoS-Protect dst-limit=15,15,src-address/10s
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=DDoS-Protect log-prefix="DDoS: MAIN-Protect"
add action=drop chain=input comment="DROP - Block all other input/forward connections on the WAN" in-interface-list=ISP
add action=drop chain=forward in-interface-list=ISP
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=ISP src-address=10.64.0.0/24
/ip firewall raw
add action=drop chain=prerouting comment="DDoS - Drop blacklist IP" in-interface-list=ISP src-address-list=ddos-blacklist