#!/usr/bin/env bash
#
#
# Created in 2020 by Kamal Hamza (khamsa.kamal48@gmail.com).
#
#

#Change directory for job
cd "$(dirname "$0")";

clear;

#Housekeeping
rm -rf Phone.json;
rm -rf Phone_Number_New.csv;

#Remove already processed lines from CSV
join -v 1 -t, <(sort -t, Phone_Number_List.csv) <(sort Phone_Number_Completed.csv) > Phone_Number_Final.csv;
mv Phone_Number_Final.csv Phone_Number_List.csv;

#Create blank.csv file
touch Phone_Number_New.csv;

#Export the header to CSV file
cat head.txt Phone_Number_New.csv > Phone_Number_New_1.csv;
mv Phone_Number_New_1.csv Phone_Number_New.csv;

#Export (Append) the last line to CSV file
tail -n 1 Phone_Number_List.csv >> Phone_Number_New.csv;

#Remove blank row
sed -i '/^$/d' Phone_Number_New.csv;

#Remove blank row
awk -F, 'length>NF+1' Phone_Number_New.csv > Phone_Number_New_1.csv;
mv Phone_Number_New_1.csv Phone_Number_New.csv;

#Check if Phone_Number_New.csv has some data to upload
a=$(cat Phone_Number_New.csv | wc -l)
b=1

if [ "$a" -eq "$b" ]; then
  echo "No phone numbers to verify";
else
  #Convert CSV to JSON
  csvjson Phone_Number_New.csv > Phone.json;

  #Remove brackets from JSON file
  tr -d '[' < Phone.json > Phone_1.json && sleep 1;
  tr -d ']' < Phone_1.json > Phone_2.json && sleep 1 && rm -rf Phone_1.json;

  #Beautify JSON file
  jq . Phone_2.json > Phone.json;
  rm -rf Phone_2.json;

  #Decide which API Key to use
  c=$(cat Phone_Number_Completed.csv | wc -l)
  d=$((c / 250))

  #If d is an integer, then delete the last API key in the CSV. If float, use the same API key
  if [[ $d =~ ^[+-]?[0-9]*$ ]]; then
    echo "API key has been used 250 times";
    echo "Will now use the next API key";
    tail -n 1 API_Keys.csv >> API_Keys_Used.csv;
    #Remove the last line from CSV file
    sed -i '$d' API_Keys.csv;
  else
    echo "API Key is still safe to use";
  fi

  #Housekeeping
  rm -rf API.json;
  rm -rf API_Key_New.csv;

  #Remove already processed lines from CSV
  join -v 1 -t, <(sort -t, API_Keys.csv) <(sort API_Keys_Used.csv) > API_Keys_Final.csv;
  mv API_Keys_Final.csv API_Keys.csv;

  #Create blank.csv file
  touch API_Key_New.csv;

  #Export the header to CSV file
  cat head_api.txt API_Key_New.csv > API_Key_New_1.csv;
  mv API_Key_New_1.csv API_Key_New.csv;

  #Export (Append) the last line to CSV file
  tail -n 1 API_Keys.csv >> API_Key_New.csv;

  #Remove blank row
  sed -i '/^$/d' API_Key_New.csv;

  #Remove blank row
  awk -F, 'length>NF+1' API_Key_New.csv > API_Key_New_1.csv;
  mv API_Key_New_1.csv API_Key_New.csv;

  #Convert CSV to JSON
  csvjson API_Key_New.csv > API.json;

  #Remove brackets from JSON file
  tr -d '[' < API.json > API_1.json && sleep 1;
  tr -d ']' < API_1.json > API_2.json && sleep 1 && rm -rf API_1.json;

  #Beautify JSON file
  jq . API_2.json > API.json;
  rm -rf API_2.json;

  #Verify Numbers
	./Verify_Numbers.sh;
fi
