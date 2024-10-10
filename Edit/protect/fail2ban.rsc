/ip firewall filter
add chain=BruteForce comment="BruteForce chain to router" action=passthougth
add action=add-src-to-address-list address-list=Banned address-list-timeout=1d chain=BruteForce comment=Blacklist  src-address-list=Stage_3
add action=add-src-to-address-list address-list=Stage_3 address-list-timeout=1h chain=BruteForce comment="Third attempt"  src-address-list=Stage_2,!secured
add action=add-src-to-address-list address-list=Stage_2 address-list-timeout=15m chain=BruteForce comment="Second attempt"  src-address-list=Stage_1
add action=add-src-to-address-list address-list=Stage_1 address-list-timeout=5m chain=BruteForce comment="First attempt" 
