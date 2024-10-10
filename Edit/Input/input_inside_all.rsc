/ip firewall filter
add chain=Input-Inside-All action=passthrough comment="Input chain from inside to router"
add chain=Input-Inside-All action=accept protocol=udp dst-port=53 
add chain=Input-Inside-All action=accept protocol=tcp dst-port=53 