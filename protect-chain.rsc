/ip firewall filter
add chain=protect comment="Filter rules for protect" action=passthrough
add chain=protect action=jump jump-target=drop src-address-list="protect"
add action=add-src-to-address-list address-list="Port Scanners" address-list-timeout=none-dynamic chain=protect in-interface-list=Internet protocol=tcp psd=21,3s,3,1





add action=jump chain=input comment="DDoS - SYN flood protection" connection-state=new in-interface-list=Internet jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect limit=200,5:packet tcp-flags=""
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=SYN-Protect log-prefix="DDoS: SYN-Protect" tcp-flags=""
add action=jump chain=input comment="DDoS - Main protection" connection-state=new in-interface-list=Internet jump-target=DDoS-Protect
add action=return chain=DDoS-Protect dst-limit=15,15,src-address/10s
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=DDoS-Protect log-prefix="DDoS: MAIN-Protect"

add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1d chain=input comment="1.2. DDoS Protect - Connection Limit" connection-limit=100,32 in-interface-list=Internet protocol=tcp
add action=tarpit chain=input connection-limit=3,32 protocol=tcp src-address-list=ddos-blacklist
add action=jump chain=forward comment="1.3. DDoS Protect - SYN Flood" connection-state=new jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=jump chain=input connection-state=new in-interface-list=Internet jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect connection-state=new limit=200,5:packet protocol=tcp tcp-flags=syn
add action=drop chain=SYN-Protect connection-state=new protocol=tcp tcp-flags=syn
add action=drop chain=input comment="1.4. Protected - Ports Scanners" src-address-list="Port Scanners"
add action=add-src-to-address-list address-list="Port Scanners" address-list-timeout=none-dynamic chain=protect in-interface-list=Internet protocol=tcp psd=21,3s,3,1