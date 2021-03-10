# lookup-and-log-public-ip-address-changes
Lookup and log public IP address changes with Linux bash script

Use's public DNS to return current public IP address

Logs current IP to a file in specified directory in /tmp along with a brief log in /tmp (though locations can be specified in the script)

This script is useful for applications that need to know their public IP address such as STUN/TURN servers (e.g. Coturn) or internet facing SIP proxies servers (e.g. Kamailio) when running in Docker containers or behind NAT/PAT.

Example use is an application script that monitors the the result of this script being run from cron, keeps the applications configuration correct and gracefully reloads the application.

For use with Corturn behind an unknown/dynamic IP (with a dynamic DNS client and Let's Encrypt with certbot) a simple cron might be:

`# m h  dom  mon dow   command`
`*/5 *  *    *   *     /bin/bash /root/lookup-and-log-public-ip-address-changes/lookup-and-log-public-ip-address-changes.sh`
`*/5 *  *    *   *     /bin/bash /root/lookup-and-log-public-ip-address-changes/example-usage-scripts/coturn-external-ip-update.sh`
`# The below entry is here for the sake of a complete example`
`30  1  1,15 *   *     /bin/bash /etc/lookup-and-log-public-ip-address-changes/example-usage-scripts/get_certificates_for_coturn.sh``

