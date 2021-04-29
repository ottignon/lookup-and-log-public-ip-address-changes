#!/bin/bash
# Example where HAProxy is being used for on the server
certbot renew --webroot --preferred-challenges http --post-hook "/usr/local/bin/lookup-and-log-public-ip-address-changes/example-usage-scripts/haproxy_ssl_consolidation.sh && rc-service haproxy reload" --quiet
