/ip firewall filter
add chain=Forward-Inside action=passthrough comment="Forward chain from inside to outside"
add chain=Forward-Inside out-interface-list=Outside