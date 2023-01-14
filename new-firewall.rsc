###### Forward Chain #####
/ip firewall filter
add chain=forward in-interface-list=ISP out-interface-list=LAN action=jump jump-target=From_ISP_to_LAN comment="Rule for forward from ISP to LAN"
add chain=From_ISP_to_LAN connection-state=established action=fasttrack-connection connection-mark=!IPSec
add chain=From_ISP_to_LAN connection-state=established action=accept
add chain=From_ISP_to_LAN connection-state=related action=fasttrack-connection connection-mark=!IPSec
add chain=From_ISP_to_LAN connection-state=related action=accept
add chain=From_ISP_to_LAN connection-state=new connection-nat-state=!dstnat action=
add chain=From_ISP_to_LAN connection-state=invalid action=drop

add chain=forward in-interface-list=LAN out-interface-list=ISP action=jump jump-target=From_LAN_to_ISP comment="Rule for forward from LAN to ISP"
add chain=From_LAN_to_ISP connection-state=established action=fasttrack-connection connection-mark=!IPSec
add chain=From_LAN_to_ISP connection-state=established action=accept
add chain=From_LAN_to_ISP connection-state=related action=fasttrack-connection connection-mark=!IPSec
add chain=From_LAN_to_ISP connection-state=related action=accept
add chain=From_LAN_to_ISP connection-state=invalid action=drop

add chain=forward in-interface-list=LAN out-interface-list=LAN action=jump jump-target=From_LAN_to_LAN comment="Rule for forward from LAN to LAN"
add chain=From_LAN_to_LAN connection-state=established action=fasttrack-connection connection-mark=!IPSec
add chain=From_LAN_to_LAN connection-state=established action=accept
add chain=From_LAN_to_LAN connection-state=related action=fasttrack-connection connection-mark=!IPSec
add chain=From_LAN_to_LAN connection-state=related action=accept
add chain=From_LAN_to_LAN connection-state=invalid action=drop
add chain=forward connection-state=invalid action=drop



