#! /bin/bash
# Author: Donald Oeser
# Date: 4/24/2024
# Purpose: To take in tickets from a website that contains information on how the person wants to set up a server then set up the server

#installing jq so the rest of the program will work
sudo apt-get install jq

#getting information from website and storing it
strCurledURL=$(curl "https://www.swollenhippo.com/ServiceNow/systems/devTickets.php" | jq)
#debug statment
echo ${strCurledURL}

#parameters to hold the server ip address and the ticket ID to get information from
strIP=$1
strTicketID=$2
#debug statments
#echo ${strIP}
#echo ${strTicketID}

#iteration value for while loop
intIteration=0

#while loop to find the ticket we need information from
while [ $1 != $(echo ${strCurledURL} | jq -r .[${intIteration}].ticketID ) ];
do
((intIteration++))
done

#debug statment
#echo $(echo ${strCurledURL} | jq -r .[${intIteration}].ticketID )

#another interation variable
intIter=0
#getting length of array of software we need to intall to know how many things to install
strSoftware=$(echo ${strCurledURL} | jq -r .[${intIteration}].softwarePackages )
#debug
#echo ${strSoftware}
intlength=$(echo ${strSoftware} | jq 'length' )
#debugstatment
#echo ${intlength}

#loop to get the items needed to install and install them
while [ "$intIter" -lt "$intlength" ];
do

strToInstall=$(echo ${strSoftware} | jq -r .[${intIter}].install)
#debugstatment
echo ${strToInstall}


((intIter++))
done





