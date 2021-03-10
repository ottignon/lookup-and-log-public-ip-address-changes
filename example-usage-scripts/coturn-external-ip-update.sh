#!/bin/bash
# rottignon 09/03/2021
# version 0.1
# future version sort debug options and add check Coturn restarted okay

coturn_configuration_file_including_path="/etc/turnserver/turnserver.conf"
current_public_ip_address_file_including_path="/tmp/lookup-and-log-public-ip-address-changes/current_public_ip_address.txt"

coturn_configured_external_ip=""
reported_external_ip=""

restart_coturn_on_update=true

debug_flag=""

if [ "$1" = "--debug" ]; then

	debug_flag=true

fi

if [ -e ${coturn_configuration_file_including_path} ]; then



	if [ $debug_flag ]; then

		printf "Coturn configuration file exists\n"

	fi

	temp_coturn_configured_external_ip=$(grep -oP '^external-ip=\K([0-9]{1,3}\.){3}[0-9]{1,3}' ${coturn_configuration_file_including_path})


	if printf "${temp_coturn_configured_external_ip}" | grep -qP '([0-9]{1,3}\.){3}[0-9]{1,3}'; then

		coturn_configured_external_ip=${temp_coturn_configured_external_ip}

		if [ $debug_flag ]; then

			printf "External IP found in Coturn configuration, coturn_configured_external_ip=${coturn_configured_external_ip}\n"
		fi

	else
		if [ $debug_flag ]; then

			printf "No external IP found in Coturn configuration\n"				                
		fi
		
	fi

else
	printf "Coturn configuration file ${coturn_configuration_file_including_path} does not exist\n"

fi

if [ -e ${current_public_ip_address_file_including_path} ]; then

	if [ $debug_flag ]; then
	
		printf "Public IP address file exists\n"
	fi

	temp_reported_external_ip=$(grep -oP '([0-9]{1,3}\.){3}[0-9]{1,3}' ${current_public_ip_address_file_including_path})

	if printf "$temp_reported_external_ip" | grep -qP '([0-9]{1,3}\.){3}[0-9]{1,3}'; then

		reported_external_ip=${temp_reported_external_ip}
		
		if [ $debug_flag ]; then

			printf "Public IP found ${current_public_ip_address_file_including_path}, reported_external_ip=${reported_external_ip}\n"
		fi
	else
		printf "No public IP found ${current_public_ip_address_file_including_path}\n"
	fi

else

	if [ $debug_flag ]; then

		printf "Public IP address file ${current_public_ip_address_file_including_path} does not exists\n"
	fi
fi

if [ ${coturn_configured_external_ip} ] && [ ${reported_external_ip} ] && [ ${coturn_configured_external_ip} != ${reported_external_ip} ]; then

	sed --follow-symlinks -i "s/${coturn_configured_external_ip}/${reported_external_ip}/g" ${coturn_configuration_file_including_path}

	if [ $debug_flag ]; then

		printf "Updated Coturn configuration file ${coturn_configuration_file_including_path}\n"

	fi


	if pgrep -x turnserver > /dev/null; then

		if [ ${restart_coturn_on_update} ]; then

			systemctl restart coturn
			# Add check Coturn restarted okay

			if [ $debug_flag ]; then
				printf "Coturn was running so restarted for new external IP configuration\n"
			fi
		else
			if [ $debug_flag ]; then
				printf "Coturn running but script configured to not restart running process\n"
			fi
		fi
	else
		if [ $debug_flag ]; then

			printf "Coturn not running so did not restart\n"
		fi
	fi
else

	if [ $debug_flag ]; then

		printf "Coturn configuration not updated\n"
	fi
fi
