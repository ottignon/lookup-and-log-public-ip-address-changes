#!/bin/bash
# rottignon 09/03/2021
# version 0.1
# future version sort debug options and if statement for sed

coturn_configuration_file_including_path="/etc/turnserver/turnserver.conf"
current_public_ip_address_file_including_path="/tmp/lookup-and-log-public-ip-address-changes/current_public_ip_address.txt"

coturn_configured_external_ip=""

if [ -e ${current_public_ip_address_file_including_path} ]; then

	echo "coturn configuration file exists"

	coturn_configured_external_ip=$(grep -oP '^external-ip=\K([0-9]{1,3}\.){3}[0-9]{1,3}' coturn_configuration_file_including_path)

fi

reported_external_ip=${coturn_configured_external_ip}

if [ -e ${current_public_ip_address_file_including_path} ]; then

	echo "public ip file exists"

	reported_external_ip=$(grep -oP '([0-9]{1,3}\.){3}[0-9]{1,3}' ${current_public_ip_address_file_including_path})

fi

sed --follow-symlinks -i "s/${coturn_configured_external_ip}/${reported_external_ip}/g" ${coturn_configuration_file_including_path}

