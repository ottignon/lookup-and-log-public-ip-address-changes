#/bin/bash
# rottignon 09/02/2021
# version 0.1
# future version sort debug with out goig to print array

output_directory="/tmp/lookup-and-log-public-ip-address-changes"
output_file="current_pubic_ip_address.txt"
output_log="public_ip_address_changes.log"
previous_public_ip=""
first_run=false
debug_flag=""

if [ "$@" = "--debug" ]; then

	debug_flag=true

fi

if [ ! -d ${output_directory} ]; then

	mkdir -p ${output_directory}
	first_run=true
fi

if [ -e ${output_directory}/${output_file} ]; then

	
	if grep -qP '([0-9]{1,3}\.){3}[0-9]{1,3}' ${output_directory}/${output_file}; then
		previous_public_ip=$(grep -oP '([0-9]{1,3}\.){3}[0-9]{1,3}' ${output_directory}/${output_file})

                if [ $debug_flag ]; then

		        printf "Regex previous public IP address is ${previous_public_ip}\n"

		fi
	fi

else
	first_run=true
fi

if [ ! -e ${output_directory}/${output_log} ]; then

	first_run=true

fi


iso_datetime=$(date --iso-8601=seconds)


current_pubic_ip_address=$(dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short)

if [ $debug_flag ]; then

	        echo "iso_datetime=${iso_datetime}"

		printf "Current public IP address (from DNS lookup) is ${current_pubic_ip_address}\n"

fi

if [ "${current_pubic_ip_address}" != "${previous_public_ip}" ]; then


	if [ ! -e ${output_directory}/${output_log} ]; then


		first_run=true

	else
		printf "$(tail -n 10 ${output_directory}/${output_log})" > ${output_directory}/${output_log} 

	fi


        printf "${current_pubic_ip_address}\n" > ${output_directory}/${output_file}
	printf "${iso_datetime} ${current_pubic_ip_address}\n" >> ${output_directory}/${output_log}


	if [ $debug_flag ]; then

		printf "Current and previous IP address do not match. Written details to ${output_directory}/${output_file} and ${output_directory}/${output_log}\n"

	fi
else

	if [ $debug_flag ]; then

		printf "Current and previous IP addresses match. No action taken.\n"
	fi
fi

if [ $debug_flag ]; then
	printf "first_run=${first_run}\n"
fi
