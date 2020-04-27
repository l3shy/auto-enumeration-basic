#!/bin/bash
# Author: l3shy
# Date: 4/26/2020
# Purpose: I wanted to create a script that automates the process of basic enumeration for me when I approach
# CTF's or vulnerable virtual machines. Furthermoe, I wanted to practice with BASH and programming in general.
# v 0.1

#Welcome message
echo -e "\nHello there! This tool is meant for very basic automated enumeration on a machine."
echo -e "This tool will create directories for the output of each scan performed.\n Currently a work in progress.\n"


#Read user input
read -p 'Target IP Address: ' ipaddr
read -p 'Output file names {Nmap,Nikto,etc.}: ' names_output

#Create directory for NMAP
mkdir nmap
nmap -sC -sV -oA nmap/$names_output $ipaddr

#Create a directory for Nikto
mkdir nikto
nikto -h http://$ipaddr -Format txt -output nikto/$names_output

#Storing HTTP status code as a variable
status=$(curl -I "www.magesh.co.in" 2>&1 | awk '/HTTP\// {print $2}')

#Assigning variable status to the HTTP status of the site
status=$(curl -I "$ipaddr" 2>&1 | awk '/HTTP\// {print $2}')

#Testing if there is a webpage
if [ "$status" != 200 ]; then
        echo 'A website may not be running. Do you want to run dirb anyway? [Y/N]' 
        read response

        if [ "$response" != "Y" ]; then
                echo "You selected 'No'."
        else
                mkdir dirb
                dirb http://$ipaddr -r -o $names_output.out
        fi
else
        echo "Website seems to be active - Starting dirb scans"
        mkdir dirb
        dirb http://$ipaddr -r -o dirb/$names_output.out

fi
