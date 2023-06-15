/ip firewall filter
add chain=fail2ban action=passthrough comment="Fail2ban filter rules"
add action=jump jump-target=drop src-address-list="f2b ban"
add action=add-src-to-address-list address-list="f2b ban" address-list-timeout=none-dynamic chain=fail2ban connection-state=new log=yes log-prefix="Gongratulations! You are in ban." src-address-list="f2b stage3"
add action=add-src-to-address-list address-list="f2b stage3" address-list-timeout=1m chain=fail2ban connection-state=new src-address-list="f2b stage2"
add action=add-src-to-address-list address-list="f2b stage2" address-list-timeout=1m chain=fail2ban connection-state=new src-address-list="f2b stage1"
add action=add-src-to-address-list address-list="f2b stage1" address-list-timeout=1m chain=fail2ban connection-state=new