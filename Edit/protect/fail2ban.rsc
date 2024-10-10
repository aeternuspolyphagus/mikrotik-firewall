/ip firewall filter
add chain=BruteForce action=passthougth comment="BruteForce chain to router"
add chain=BruteForce action=add-src-to-address-list address-list=Banned src-address-list=Stage_3 address-list-timeout=1d  comment=Blacklist 
add chain=BruteForce action=add-src-to-address-list address-list=Stage_3 src-address-list=Stage_2,!secured address-list-timeout=1h  comment="Third attempt" 
add chain=BruteForce action=add-src-to-address-list address-list=Stage_2 src-address-list=Stage_1 address-list-timeout=15m  comment="Second attempt" 
add chain=BruteForce action=add-src-to-address-list address-list=Stage_1 address-list-timeout=5m  comment="First attempt" 
add chain=Bruteforce action=accept 