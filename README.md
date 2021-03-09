# lookup-and-log-public-ip-address-changes
Lookup and log public IP address changes with Linux bash script

Use's public DNS to return current public IP address

Logs current IP to a file in specified directory in /tmp along with a brief log in /tmp (though locations can be specified in the script)

This script is useful for applications behind NAT that need to know their public IP address, for example docker or STUN/TURN servers.

Example use is an application script that monitors the the result of this script being run from cron, keeps the applications configuration correct and gracefully reloads the application.
