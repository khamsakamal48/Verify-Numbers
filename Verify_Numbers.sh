#!/usr/bin/env bash
#
#
# Created in 2020 by Kamal Hamza (khamsa.kamal48@gmail.com).
#
#

#Change directory for job
cd "$(dirname "$0")";

#Get phone number and API Key
number=$(jq -r '.number' Phone.json | tr -d ' ' | tr -d '-' | tr -d '+' | tr -d '('| tr -d ')')
number_length=$(echo "${#number}")
access_key=$(jq -r '.access_key' API.json)

#Verify based on the length of mobile number
if [[ "$number_length" == 10 ]]; then
  #Mobile No. is of 10 digits.
  curl -s "http://apilayer.net/api/validate?access_key=${access_key}&number=${number}" 2>&1 | tee Number_Verify_Output.json;
else
  #Mobile No. is not of 10 digits.
  curl -s "http://apilayer.net/api/validate?access_key=${access_key}&number=${number}&country_code=IN" 2>&1 | tee Number_Verify_Output.json;
fi

#Check Log
error_status=$(jq -r '.error' Number_Verify_Output.json)

case $error_status in

  false)
    code=$(jq -r '.error | .code' Number_Verify_Output.json)
    type=$(jq -r '.error | .type' Number_Verify_Output.json)
		info=$(jq -r '.error | .info' Number_Verify_Output.json)
    echo "$code,$type,$info" >> Phone_List_Final.csv;
    ;;

  *)
    valid=$(jq -r '.valid' Number_Verify_Output.json)
    number=$(jq -r '.number' Number_Verify_Output.json)
		local_format=$(jq -r '.local_format' Number_Verify_Output.json)
		international_format=$(jq -r '.international_format' Number_Verify_Output.json)
    country_prefix=$(jq -r '.country_prefix' Number_Verify_Output.json)
    country_code=$(jq -r '.country_code' Number_Verify_Output.json)
		country_name=$(jq -r '.country_name' Number_Verify_Output.json)
		location=$(jq -r '.location' Number_Verify_Output.json)
    carrier=$(jq -r '.carrier' Number_Verify_Output.json)
		line_type=$(jq -r '.line_type' Number_Verify_Output.json)
    echo "$valid,$number,$local_format,$international_format,$country_prefix,$country_code,$country_name,$location,$carrier,$line_type" >> Phone_List_Final.csv;
    ;;

esac

tail -n 1 Phone_Number_List.csv >> Phone_Number_Completed.csv;
#Remove the last line from CSV file
sed -i '$d' Phone_Number_List.csv;

#Sleep for 10 seconds
sleep 10;
