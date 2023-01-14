/ip firewall filter
add action=accept chain=input comment="default configuration" connection-state=established,related
add action=accept chain=input src-address-list=allowed_to_router
add action=accept chain=input protocol=icmp
add action=drop chain=input
/ip firewall address-list
add address=192.168.88.2-192.168.88.254 list=allowed_to_router


/ip firewall filter
add action=fasttrack-connection chain=forward comment=FastTrack connection-state=established,related
add action=accept chain=forward comment="Established, Related" connection-state=established,related
add action=drop chain=forward comment="Drop invalid" connection-state=invalid log=yes log-prefix=invalid
add action=drop chain=forward comment="Drop tries to reach not public addresses from LAN" dst-address-list=not_in_internet in-interface=bridge log=yes log-prefix=!public_from_LAN out-interface=!bridge
add action=drop chain=forward comment="Drop incoming packets that are not NAT`ted" connection-nat-state=!dstnat connection-state=new in-interface=ether1 log=yes log-prefix=!NAT
add action=jump chain=forward protocol=icmp jump-target=icmp comment="jump to ICMP filters"
add action=drop chain=forward comment="Drop incoming from internet which is not public IP" in-interface=ether1 log=yes log-prefix=!public src-address-list=not_in_internet
add action=drop chain=forward comment="Drop packets from LAN that do not have LAN IP" in-interface=bridge log=yes log-prefix=LAN_!LAN src-address=!192.168.88.0/24

/ip firewall filter
add chain=icmp protocol=icmp icmp-options=0:0 action=accept comment="echo reply"
add chain=icmp protocol=icmp icmp-options=3:0 action=accept comment="net unreachable"
add chain=icmp protocol=icmp icmp-options=3:1 action=accept comment="host unreachable"
add chain=icmp protocol=icmp icmp-options=3:4 action=accept comment="host unreachable fragmentation required"
add chain=icmp protocol=icmp icmp-options=8:0 action=accept comment="allow echo request"
add chain=icmp protocol=icmp icmp-options=11:0 action=accept comment="allow time exceed"
add chain=icmp protocol=icmp icmp-options=12:0 action=accept comment="allow parameter bad"
add chain=icmp action=drop comment="deny all other types"

/ip firewall filter
add action=accept chain=input comment="defconf: accept ICMP after RAW" protocol=icmp
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop all not coming from LAN" in-interface-list=!LAN

/ip firewall filter
add action=add-src-to-address-list address-list=bruteforce_blacklist address-list-timeout=1d chain=input comment=Blacklist connection-state=new dst-port=22 protocol=tcp src-address-list=connection3
add action=add-src-to-address-list address-list=connection3 address-list-timeout=1h chain=input comment="Third attempt" connection-state=new dst-port=22 protocol=tcp src-address-list=connection2,!secured
add action=add-src-to-address-list address-list=connection2 address-list-timeout=15m chain=input comment="Second attempt" connection-state=new dst-port=22 protocol=tcp src-address-list=connection1
add action=add-src-to-address-list address-list=connection1 address-list-timeout=5m chain=input comment="First attempt" connection-state=new dst-port=22 protocol=tcp
add action=accept chain=input dst-port=22 protocol=tcp src-address-list=!bruteforce_blacklist

/ip firewall filter
add chain=forward connection-state=new action=jump jump-target=detect-ddos
add action=return chain=detect-ddos dst-limit=32,32,src-and-dst-addresses/10s
add action=add-dst-to-address-list address-list=ddos-targets address-list-timeout=10m chain=detect-ddos
add action=add-src-to-address-list address-list=ddos-attackers address-list-timeout=10m chain=detect-ddos
/ip firewall raw
add action=drop chain=prerouting dst-address-list=ddos-targets src-address-list=ddos-attackers

/ip/settings/set tcp-syncookies=yes

/ip/firewall/filter 
add action=return chain=detect-ddos dst-limit=32,32,src-and-dst-addresses/10s protocol=tcp tcp-flags=syn,ack

/ip firewall filter
add chain=input in-interface-list=ISP action=jump jump-target=ISP-Input
add chain=forward in-interface-list=ISP action=jump jump-target=ISP-Forward

add chain=ISP-Input connection-state=established action=accept 
add chain=ISP-Input connection-state=related action=accept
add chain=ISP-Input connection-state=untracked action=accept
add chain=ISP-Input connection-state=invalid action=drop
add chain=ISP-Input jump-target=ISP-Input-Allow action=jump
add chain=ISP-Input action=drop

add chain=ISP-Forward connection-state=established action=accept
add chain=ISP-Forward connection-state=related action=accept
add chain=ISP-Forward connection-state=untracked action=accept
add chain=ISP-Forward connection-state=invalid action=drop
add chain=ISP-Forward connection-nat-state=dstnat action=accept
add chain=ISP-Forward action=drop

add chain=ISP-Input-Allow protocol=icmp action=accept
add chain=ISP-Input-Allow dst-port=22 protocol=tcp action=accept
add chain=ISP-Input-Allow dst-port=1701 protocol=udp action=accept

/ip firewall filter
add chain=input in-interface-list=Local action=jump jump-target=Local-Input

# Local-Input -->
add chain=Local-Input connection-state=established 
add chain=Local-Input connection-state=related 
add chain=Local-Input connection-state=untracked 
add chain=Local-Input action=jump jump-target=Local-Input-All
add chain=Local-Input connection-state=invalid action=drop
add chain=Local-Input action=drop
# Local-Input <--

# Local-Input-All -->
add chain=Local-Input-All protocol=icmp 
add chain=Local-Input-All protocol=udp dst-port=53 
add chain=Local-Input-All in-interface=ether5.3 protocol=tcp dst-port=22,8291 
# Local-Input-All <--

# Forward -->
add chain=forward connection-state=established 
add chain=forward connection-state=related 
add chain=forward connection-state=invalid action=drop
add chain=forward in-interface=ether5.2 action=jump jump-target=Forward-from-ether5.2
add chain=forward in-interface=ether5.3 action=jump jump-target=Forward-from-ether5.3
add chain=forward in-interface=ether5.4 action=jump jump-target=Forward-from-ether5.4
add chain=forward in-interface=ether5.5 action=jump jump-target=Forward-from-ether5.5
add chain=forward in-interface=ether5.6 action=jump jump-target=Forward-from-ether5.6
add chain=forward action=drop
# Forward <--

# Forward-from-ether5.6 -->
add chain=Forward-from-ether5.6 out-interface-list=ISP 
# Forward-from-ether5.6 <--

# Forward-from-ether5.5 -->
add chain=Forward-from-ether5.5 protocol=icmp
add chain=Forward-from-ether5.5 src-address=192.168.5.2 dst-address-list=voip.provider protocol=udp dst-port=5060
add chain=Forward-from-ether5.5 src-address=192.168.5.2 dst-address-list=voip.provider protocol=tcp dst-port=5060
add chain=Forward-from-ether5.5 src-address-list=ActiveDirectoryServers out-interface=ether5.2 
add chain=Forward-from-ether5.5 src-address-list=ActiveDirectoryServers out-interface-list=ISP protocol=udp dst-port=53
# Forward-from-ether5.5 <--

# Forward-from-ether5.4 -->
add chain=Forward-from-ether5.4 dst-address=192.168.5.2 protocol=udp dst-port=69 comment="TFTP"
add chain=Forward-from-ether5.4 dst-address=192.168.5.2 protocol=udp dst-port=5060 comment="SIP"
add chain=Forward-from-ether5.4 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=53 comment="DNS"
add chain=Forward-from-ether5.4 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=123 comment="NTP"
add chain=Forward-from-ether5.4 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=636 comment="LDAP BOOK"
add chain=Forward-from-ether5.4 dst-address=192.168.5.4 protocol=udp dst-port=514 comment="LOG"
# Forward-from-ether5.4 <--

# Forward-from-ether5.3 -->
add chain=Forward-from-ether5.3 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=53 comment="DNS"
add chain=Forward-from-ether5.3 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=123 comment="NTP"
add chain=Forward-from-ether5.3 dst-address=192.168.5.4 protocol=udp dst-port=514 comment="LOG"
# Forward-from-ether5.3 <--

# Forward-from-ether5.2 -->
add chain=Forward-from-ether5.2 out-interface-list=ISP
add chain=Forward-from-ether5.2 src-address-list=PCadmins
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=icmp
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=445 comment="AD-SMB"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=123 comment="AD-W32Time"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=464 comment="AD-Kerberos password change"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=389 comment="AD-LDAP"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=53 comment="AD-DNS"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=udp dst-port=88 comment="AD-Kerberos"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=135 comment="AD-RPC Endpoint Mapper"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=464 comment="AD-Kerberos password change"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=389 comment="AD-LDAP"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=636 comment="AD-LDAP SSL"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=3268 comment="AD-LDAP GC"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=3269 comment="AD-LDAP GC SSL"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=53 comment="AD-DNS"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=49152-65535 comment="AD-RPC for LSA, SAM,NetLogon, FRS, DFSR"
add chain=Forward-from-ether5.2 dst-address-list=ActiveDirectoryServers protocol=tcp dst-port=88 comment="AD-Kerberos"


/ip firewall filter
add action=accept chain=forward comment="1.1. Forward and Input Established and Related connections" connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=drop chain=forward connection-nat-state=!dstnat connection-state=new in-interface-list=Internet
add action=accept chain=input connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1d chain=input comment="1.2. DDoS Protect - Connection Limit" connection-limit=100,32 in-interface-list=Internet protocol=tcp
add action=tarpit chain=input connection-limit=3,32 protocol=tcp src-address-list=ddos-blacklist
add action=jump chain=forward comment="1.3. DDoS Protect - SYN Flood" connection-state=new jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=jump chain=input connection-state=new in-interface-list=Internet jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect connection-state=new limit=200,5:packet protocol=tcp tcp-flags=syn
add action=drop chain=SYN-Protect connection-state=new protocol=tcp tcp-flags=syn
add action=drop chain=input comment="1.4. Protected - Ports Scanners" src-address-list="Port Scanners"
add action=add-src-to-address-list address-list="Port Scanners" address-list-timeout=none-dynamic chain=input in-interface-list=Internet protocol=tcp psd=21,3s,3,1
add action=drop chain=input comment="1.5. Protected - WinBox Access" src-address-list="Black List Winbox"
add action=add-src-to-address-list address-list="Black List Winbox" address-list-timeout=none-dynamic chain=input connection-state=new dst-port=8291 in-interface-list=Internet log=yes log-prefix="BLACK WINBOX" protocol=tcp src-address-list="Winbox Stage 3"
add action=add-src-to-address-list address-list="Winbox Stage 3" address-list-timeout=1m chain=input connection-state=new dst-port=8291 in-interface-list=Internet protocol=tcp src-address-list="Winbox Stage 2"
add action=add-src-to-address-list address-list="Winbox Stage 2" address-list-timeout=1m chain=input connection-state=new dst-port=8291 in-interface-list=Internet protocol=tcp src-address-list="Winbox Stage 1"
add action=add-src-to-address-list address-list="Winbox Stage 1" address-list-timeout=1m chain=input connection-state=new dst-port=8291 in-interface-list=Internet protocol=tcp
add action=accept chain=input dst-port=8291 in-interface-list=Internet protocol=tcp
add action=drop chain=input comment="1.6. Protected - OpenVPN Connections" src-address-list="Black List OpenVPN"
add action=add-src-to-address-list address-list="Black List OpenVPN" address-list-timeout=none-dynamic chain=input connection-state=new dst-port=1194 in-interface-list=Internet log=yes log-prefix="BLACK OVPN" protocol=tcp src-address-list="OpenVPN Stage 3"
add action=add-src-to-address-list address-list="OpenVPN Stage 3" address-list-timeout=1m chain=input connection-state=new dst-port=1194 in-interface-list=Internet protocol=tcp src-address-list="OpenVPN Stage 2"
add action=add-src-to-address-list address-list="OpenVPN Stage 2" address-list-timeout=1m chain=input connection-state=new dst-port=1194 in-interface-list=Internet protocol=tcp src-address-list="OpenVPN Stage 1"
add action=add-src-to-address-list address-list="OpenVPN Stage 1" address-list-timeout=1m chain=input connection-state=new dst-port=1194 in-interface-list=Internet protocol=tcp
add action=accept chain=input dst-port=1194 in-interface-list=Internet protocol=tcp
add action=accept chain=input comment="1.7. Access OpenVPN Tunnel Data" in-interface-list=VPN
add action=accept chain=input comment="1.8. Access Normal Ping" in-interface-list=Internet limit=50/5s,2:packet protocol=icmp
add action=drop chain=input comment="1.9. Drop All Other" in-interface-list=Internet

/ip firewall raw
add action=drop chain=prerouting dst-port=137,138,139 in-interface-list=Internet protocol=udp

/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=established,related
add action=accept chain=forward comment="ALLOW - Established, Related and connections" connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=drop chain=forward comment="DROP - Invalid connections" connection-state=invalid
add action=drop chain=input connection-state=invalid
add action=jump chain=input comment="DDoS - SYN flood protection" connection-state=new in-interface-list=Internet jump-target=SYN-Protect protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect limit=200,5:packet tcp-flags=""
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=SYN-Protect log-prefix="DDoS: SYN-Protect" tcp-flags=""
add action=jump chain=input comment="DDoS - Main protection" connection-state=new in-interface-list=Internet jump-target=DDoS-Protect
add action=return chain=DDoS-Protect dst-limit=15,15,src-address/10s
add action=add-src-to-address-list address-list=ddos-blacklist address-list-timeout=1w3d chain=DDoS-Protect log-prefix="DDoS: MAIN-Protect"
add action=drop chain=input comment="DROP - Block all other input/forward connections on the WAN" in-interface-list=Internet
add action=drop chain=forward in-interface-list=Internet
/ip firewall raw
add action=drop chain=prerouting comment="DDoS - Drop blacklist IP" in-interface-list=Internet src-address-list=ddos-blacklist

/ip firewall filter
add action=fasttrack-connection chain=forward comment=\
    "ALLOW - Established, Related connections" connection-state=\
    established,related hw-offload=yes
add action=accept chain=forward connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=drop chain=forward comment="DROP - Invalid connections" \
    connection-state=invalid
add action=drop chain=input connection-state=invalid
add action=jump chain=input comment="DDoS - SYN flood protection" \
    connection-state=new in-interface-list=ISP jump-target=SYN-Protect \
    protocol=tcp tcp-flags=syn
add action=return chain=SYN-Protect limit=200,5:packet tcp-flags=""
add action=add-src-to-address-list address-list=ddos-blacklist \
    address-list-timeout=1w3d chain=SYN-Protect log-prefix="DDoS: SYN-Protect" \
    tcp-flags=""
add action=jump chain=input comment="DDoS - Main protection" connection-state=\
    new in-interface-list=ISP jump-target=DDoS-Protect
add action=return chain=DDoS-Protect dst-limit=15,15,src-address/10s
add action=add-src-to-address-list address-list=ddos-blacklist \
    address-list-timeout=1w3d chain=DDoS-Protect log-prefix=\
    "DDoS: MAIN-Protect"
add action=drop chain=input comment=\
    "DROP - Block all other input/forward connections on the WAN" \
    in-interface-list=ISP
add action=drop chain=forward in-interface-list=ISP
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=\
    out,none out-interface-list=ISP src-address=10.64.0.0/24
/ip firewall raw
add action=drop chain=prerouting comment="DDoS - Drop blacklist IP" \
    in-interface-list=ISP src-address-list=ddos-blacklist

