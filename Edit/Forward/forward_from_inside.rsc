/ip firewall filter
add chain=Forward-Inside action=passthrough comment="Forward chain from inside to outside"
add chain=Forward-Inside action=jump jump-target=Drop-chain in-interface-list=Inside out-interface-list=!Inside dst-address-list=not_in_internet

add chain=Forward-Inside action=accept in-interface-list=Inside out-interface-list=Outside
add chain=Forward-Inside action=accept in-interface-list=Inside out-interface-list=Inside