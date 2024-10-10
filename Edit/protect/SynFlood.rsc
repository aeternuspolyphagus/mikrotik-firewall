/ip firewall filter
add chain=Detect-SynFlood comment="SynFlood detect chain" action=passthougth
add chain=Detect-SynFlood connection-state=new limit=200,5:packet protocol=tcp tcp-flags=syn action=return
add chain=Detect-SynFlood address-list=ddos-blacklist address-list-timeout=1w3d action=add-dst-to-address-list