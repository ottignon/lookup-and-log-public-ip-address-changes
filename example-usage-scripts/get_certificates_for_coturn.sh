#!/bin/bash
# Example where HAProxy is being used on the server, certbot needs a backend where it can store challenge file such as .well-known/acme-challenge on NGINX or Apache
# Alternatively certbot can be used in standalone mode
certbot renew --webroot --preferred-challenges http --post-hook "/usr/local/bin/lookup-and-log-public-ip-address-changes/example-usage-scripts/haproxy_ssl_consolidation.sh && rc-service haproxy reload" --quiet
