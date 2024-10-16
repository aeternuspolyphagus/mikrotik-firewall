# mikrotik-firewall
My humble vision on mikrotik about firewall rules.

#### Input chain
```
  /ip firewall filter
  add chain=input action=passthrough comment="Input chain to router"
  add chain=input action=jump jump-target=Icmp-Chain protocol=icmp
  add chain=input action=jump jump-target=Protected-chain
  add chain=input action=jump jump-target=Input-Outside in-interface-list=Outside
  add chain=input action=jump jump-target=Input-Inside in-interface-list=Inside
  add chain=input action=jump jump-target=Drop-chain in-interface-list=!Outside disabled=yes
  add chain=input action=jump jump-target=Drop-chain in-interface-list=!Inside disabled=yes
```
####  Input chain from Outside
```
    /ip firewall filter
    add chain=Input-Outside action=passthougth comment="Input chain to router from outside"
    add chain=Input-Outside action=accept connection-state=established
    add chain=Input-Outside action=accept connection-state=related
    add chain=Input-Outside action=accept connection-state=untracked
    add chain=Input-Outside action=jump jump-target=Drop-chain connection-state=invalid
    add chain=Input-Outside action=accept ipsec-policy=in,ipsec action=accept
    add chain=Input-Outside action=jump jump-target=Input-Outside-Allow
    add chain=Input-Outside action=jump jump-target=Drop-chain

    /ip firewall filter
    add chain=Input-Outside-Allow  action=passthougth comment="Allow input chain to router from outside"
    add chain=Input-Outside-Allow  action=jump jump-target=BruteForce protocol=tcp dst-port=22 connection-nat-state=dstnat
    add chain=Input-Outside-Allow  action=jump jump-target=BruteForce protocol=tcp dst-port=8291
```
#### Input chain from Inside
```
    /ip firewall filter
    add chain=Input-Inside action=passthougth comment="Input chain to router from inside" 
    add chain=Input-Inside action=accept connection-state=established 
    add chain=Input-Inside action=accept connection-state=related 
    add chain=Input-Inside action=accept connection-state=untracked 
    add chain=Input-Inside action=jump jump-target=Drop-chain connection-state=invalid
    add chain=Input-Inside action=jump jump-target=Input-Inside-All
    add chain=Input-Inside action=jump jump-target=Drop-chain

    /ip firewall filter
    add chain=Input-Inside-All action=passthrough comment="Input chain from inside to router"
    add chain=Input-Inside-All action=accept protocol=udp dst-port=53 
    add chain=Input-Inside-All action=accept protocol=tcp dst-port=53
    add chain=Input-Inside-All action=accept src-address-list=MNGMNT protocol=tcp dst-port=22
    add chain=Input-Inside-All action=accept src-address-list=MNGMNT protocol=tcp dst-port=8291
    add chain=Input-Inside-All action=jump jump-target=Drop-chain
```
#### Forward Chain
```
    /ip firewall filter
    add chain=forward action=passthrough comment="Forward chain"
    add chain=forward action=fasttrack-connection connection-state=established connection-mark=!ipsec 
    add chain=forward action=fasttrack-connection connection-state=related connection-mark=!ipsec 
    add chain=forward action=accept connection-state=established
    add chain=forward action=accept connection-state=related
    add chain=forward action=accept connection-state=untracked
    add chain=forward action=jump jump-target=Drop-chain connection-state=invalid
    add action=drop chain=forward src-address-list=no_forward_ipv4
    add action=drop chain=forward dst-address-list=no_forward_ipv4
    add chain=forward action=jump jump-target=Protected-chain
    add chain=forward in-interface-list=Outside action=jump jump-target=Forward-Outside
    add chain=forward in-interface-list=Inside action=jump jump-target=Forward-Inside
```
#### Forward from Outside
```
    /ip firewall filter
    add chain=Forward-Outside action=passthrough comment="Forward chain from outside to inside"
    add chain=Forward-Outside action=accept ipsec-policy=in,ipsec action=accept
    add chain=Forward-Outside action=jump jump-target=Drop-chain connection-nat-state=!dstnat connection-state=new
    add chain=Forward-Outside action=jump jump-target=Drop-chain in-interface-list=Outside out-interface-list=!Inside src-address-list=not_in_internet
    add chain=Forward-Outside connection-nat-state=dstnat action=accept
    add chain=Forward-Outside action=jump jump-target=Drop-chain
```
#### FOrward from Inside ####
```
    /ip firewall filter
    add chain=Forward-Inside action=passthrough comment="Forward chain from inside to outside"
    add chain=Forward-Inside action=jump jump-target=Drop-chain in-interface-list=Inside out-interface-list=!Inside dst-address-list=not_in_internet
    add chain=Forward-Inside action=accept in-interface-list=Inside out-interface-list=Outside
    add chain=Forward-Inside action=accept in-interface-list=Inside out-interface-list=Inside
```
#### ICMP chain
```
    /ip firewall filter
    add chain=Icmp-Chain action=passthougth comment="ICMP chain" 
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=0:0 comment="echo reply"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:0 comment="net unreachable"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:1 comment="host unreachable"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=3:4 comment="host unreachable fragmentation required"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=8:0 comment="allow echo request"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=11:0 comment="allow time exceed"
    add chain=Icmp-Chain action=accept protocol=icmp icmp-options=12:0 comment="allow parameter bad"
    add chain=Icmp-Chain action=jump jump-target=Drop-chain
```
#### fail2ban chain
```
    /ip firewall filter
    add chain=BruteForce action=passthougth comment="BruteForce chain to router"
    add chain=BruteForce action=add-src-to-address-list address-list=Banned src-address-list=Stage_3 address-list-timeout=1d  comment=Blacklist 
    add chain=BruteForce action=add-src-to-address-list address-list=Stage_3 src-address-list=Stage_2,!secured address-list-timeout=1h  comment="Third attempt" 
    add chain=BruteForce action=add-src-to-address-list address-list=Stage_2 src-address-list=Stage_1 address-list-timeout=15m  comment="Second attempt" 
    add chain=BruteForce action=add-src-to-address-list address-list=Stage_1 address-list-timeout=5m  comment="First attempt" 
    add chain=Bruteforce action=accept 
```
#### Security chain
```
    /ip firewall filter
    add chain=Protected-chain action=passthougth comment="Protect chain"
    add chain=Protected-chain action=jump jump-target=Detect-DDoS connection-state=new
    add chain=Protected-chain action=jump jump-target=Detect-SynFlood connection-state=new protocol=tcp tcp-flags=syn
    add chain=Protected-chain action=jump jump-target=Detect-SynAttack connection-state=new
    add chain=Protected-chain action=jump jump-target=Detect-PortScanners connection-state=new

    /ip firewall filter
    add chain=Detect-DDoS action=passthougth comment="DDoS detect chain" 
    add chain=Detect-DDoS action=return dst-limit=32,32,src-and-dst-addresses/10s 
    add chain=Detect-DDoS action=add-dst-to-address-list address-list=ddos-targets address-list-timeout=10m 
    add chain=Detect-DDoS action=add-src-to-address-list address-list=ddos-attackers address-list-timeout=10m 

    /ip firewall filter
    add chain=Detect-SynFlood action=passthougth comment="SynFlood detect chain"
    add chain=Detect-SynFlood action=return connection-state=new protocol=tcp tcp-flags=syn limit=200,5:packet
    add chain=Detect-SynFlood action=add-dst-to-address-list address-list=Banned address-list-timeout=1w3d

    /ip settings 
    set tcp-syncookies=yes

    /ip firewall filter
    add chain=Detect-SynAttack action=passthougth comment="SynAttack detect chain"
    add chain=Detect-SynAttack action=return protocol=tcp tcp-flags=syn,ack dst-limit=32,32,src-and-dst-addresses/10s
    add chain=Detect-SynAttack action=add-dst-to-address-list address-list=Banned address-list-timeout=1w3d

    /ip firewall filter
    add chain=Detect-Portscanners action=passthougth comment="Port scanner detect chain" action=passthougth
    add chain=Detect-Portscanners action=add-src-to-address-list address-list=Banned address-list-timeout=none-dynamic protocol=tcp psd=21,3s,3,1
```
#### Drop chain
```
    /ip firewall filter
    add chain=Drop-chain action=passthrough comment="Main drop chain"
    add chain=Drop-chain action=drop
```
#### Raw mangle chain 
```
    /ip firewall raw
    add chain=prerouting action=passthrough comment="Drop from prerouting"
    add chain=prerouting action=drop src-address-list=Banned
    add chain=prerouting action=drop src-address-list=ddos-attackers dst-address-list=ddos-targets
```
#### Mangle chain
```
    /ip firewall mangle
    add action=mark-connection chain=input comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=in,ipsec new-connection-mark=ipsec
    add action=mark-connection chain=output comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=out,ipsec new-connection-mark=ipsec 
    add action=mark-connection chain=forward comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=out,ipsec new-connection-mark=ipsec 
    add action=mark-connection chain=forward comment="mark ipsec connections to exclude them from fasttrack" ipsec-policy=in,ipsec new-connection-mark=ipsec
```
#### Address-Lists
```
    /ip firewall address-list
    add list=ddos-attackers
    add list=ddos-targets
    add list=Banned

    /ip firewall address-list
    add address=0.0.0.0/8 comment="RFC6890" list=not_in_internet
    add address=172.16.0.0/12 comment="RFC6890" list=not_in_internet
    add address=192.168.0.0/16 comment="RFC6890" list=not_in_internet
    add address=10.0.0.0/8 comment="RFC6890" list=not_in_internet
    add address=169.254.0.0/16 comment="RFC6890" list=not_in_internet
    add address=127.0.0.0/8 comment="RFC6890" list=not_in_internet
    add address=224.0.0.0/4 comment="Multicast" list=not_in_internet
    add address=198.18.0.0/15 comment="RFC6890" list=not_in_internet
    add address=192.0.0.0/24 comment="RFC6890" list=not_in_internet
    add address=192.0.2.0/24 comment="RFC6890" list=not_in_internet
    add address=198.51.100.0/24 comment="RFC6890" list=not_in_internet
    add address=203.0.113.0/24 comment="RFC6890" list=not_in_internet
    add address=100.64.0.0/10 comment="RFC6890" list=not_in_internet
    add address=240.0.0.0/4 comment="RFC6890" list=not_in_internet
    add address=192.88.99.0/24 comment="RFC 3068" list=not_in_internet

    /ip firewall address-list
    add address=0.0.0.0/8 comment="RFC6890" list=no_forward_ipv4
    add address=169.254.0.0/16 comment="RFC6890" list=no_forward_ipv4
    add address=224.0.0.0/4 comment="multicast" list=no_forward_ipv4
    add address=255.255.255.255/32 comment="RFC6890" list=no_forward_ipv4
```
#### NAT ####
```
    /ip firewall nat
    add chain=srcnat action=accept ipsec-policy=out,ipsec
    add chain=dstnat action=accept ipsec-policy=in,ipsec
    add chain=srcnat action=masquerade out-interface-list=Outside

```
