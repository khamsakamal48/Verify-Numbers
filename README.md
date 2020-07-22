# Verify Phone Numbers

This program will verify the contact numbers using [Numverify's](https://numverify.com) API.

## Pre-requisite

* Create an account in [Numverify](https://numverify.com) and get your [API access key](https://numverify.com/documentation).

* Make sure that you install below apt packages on your Linux machine before running the program.

    ```bash
    sudo apt install curl jq csvkit
    ```

## Usage
* Download or Clone the project onto your machine.
* Enter the Phone Numbers that you want to verify in **Phone_Number_List.csv**.
* Enter the API access keys that you will be using in **API_Keys.csv**.
* Open a terminal to the project folder, run below command and follow instructions. Your final data is saved in **Phone_List_Final.csv**.

   ```bash
   ./Start.sh
  ```

## Extra information
The script checks for the verification of available phone numbers every other second.

It will auto-switch to the next API Key after exhaustion of 250 Free usages. You can support [Numverify](https://numverify.com) by subscribing to their [premium plans](https://numverify.com/plan) to get more quota on usage and tons of features.

This project is just for educational purposes only.
