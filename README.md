*before you run the script find the MAC address for you kindle and replace the MAC address in the script with your Kindle's MAC address.*

*find the device location and name using:*
```ip link show```

*then*
```ip link show <name> | grep "link/ether"```
*to get MAC address*

*Run setup script:*
``````./kindle4-setup.sh``````

*If successful, SSH in:*
``````ssh root@192.168.15.244``````

*otherwise you need to find the kindle's SSH ip
 Mount the Kindle and check its config:*
``````mount | grep -i kindle  * Find mount point``````
``````cat /path/to/kindle/usbnet/etc/config``````

*Look for lines like:
 HOST_IP=192.168.15.201
 KINDLE_IP=192.168.15.244*

*or try these common ones:*
``````ssh root@192.168.15.244
ssh root@192.168.2.2     
ssh root@192.168.191.1   
ssh root@10.0.0.2``````  

*or try the universal discovery script*
