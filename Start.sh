#!/usr/bin/env bash
#
#
# Created in 2020 by Kamal Hamza (khamsa.kamal48@gmail.com).
#
#

#Change directory for job
cd "$(dirname "$0")";

#Take a backup of Phone numbers completed and API Keys used
echo "This script will verify the phone numbers using Numverify's API."
echo ""
echo "Make sure that you have already taken backup of the numbers already verified."
echo ""
echo "Enter the Phone numbers & API Keys in 'Phone_Number_List.csv' & 'API_Keys.csv' respectively."
echo ""
read -r -p "Have you correctly entered the data in the CSV files? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        #Housekeeping
        rm -rf *.json;
        rm -rf API_Keys_Used.csv;
        rm -rf Phone_Number_Completed.csv;
        rm -rf Phone_Number_New.csv;

        touch Phone_Number_Completed.csv;
        touch API_Key_New.csv;
        touch API_Keys_Used.csv;

        #Count the no. of APIs
        api_count=$(cat API_Keys.csv | wc -l)

        #Count the phone numbers to process
        phone_count=$(cat Phone_Number_List.csv | wc -l)

        #Check whether API Keys are sufficient for all the phone numbers
        api_required=$((phone_count / 250))

        if [[ "$api_count" -ge "$api_required" ]]; then
          echo "API Keys are sufficient";
          for i in $(seq $phone_count); do ./csvtojson.sh; done
        else
          echo "API Keys are not sufficient"
          echo "Visit https://numverify.com and create a new account to get more API Keys."
          echo "Once you generate API Keys, add them in the 'API_Keys.csv' file."
        fi
        ;;
    *)
        echo "See you later!"
        ;;
esac
