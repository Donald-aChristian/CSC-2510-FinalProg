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





