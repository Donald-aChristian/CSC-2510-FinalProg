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
while [ $2 != $(echo ${strCurledURL} | jq -r .[${intIteration}].ticketID ) ];
do
((intIteration++))
done

#getting information to be put into the log file
strSDate=$(echo ${strCurledURL} | jq -r .[${intIteration}].submissionDate)
strRequestor=$(echo ${strCurledURL} | jq -r  .[${intIteration}].requestor)
strConfig=$(echo ${strCurledURL} | jq -r  .[${intIteration}].standardConfig)
strHostNamee=$(hostname)

#debugstatment
#echo ${strSDate}
#echo ${strRequestor}
#echo ${strConfig}

#making the directory and log file
mkdir "configurationLogs"
echo "TicketID: $2" >> "configurationLogs/$2.log"
echo "Requestor: $strRequestor" >> "configurationLogs/$2.log"
echo "External IP Address: $1" >> "configurationLogs/$2.log"
echo "Hostname: $strHostName" >> "configurationLogs/$2.log"
echo "Standard Configuration: $strConfig" >> "configurationLogs/$2.log"


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
strSP=$(echo ${strSoftware} | jq -r .[${intIter}].name)
#debugstatment
#echo ${strToInstall}

sudo apt-get install ${strToInstall}

echo "softwarePackage - $strSP" >> "configurationLogs/$2.log"

((intIter++))
done

#another interation value
intIter2=0

#Holds the array of additional configurations to be done to the server
strAddCon=$(echo ${strCurledURL} | jq -r .[${intIteration}].additionalConfigs )

#gets length of the config array for while loop
intAddlength=$(echo ${strAddCon} | jq 'length' )

#loops through all the aditional conditions and does them
while [ "$intIter2" -lt "$intAddlength" ];
do
#gets the configuration to do
strToDo=$(echo ${strAddCon} | jq -r .[${intIter2}].config )
strConName=$(echo ${strAddCon} | jq -r .[${intIter2}].name )
#does the configuration command
${strToDo}

echo "additionalConfig - $strConName" >> "configurationLogs/$2.log"

((intIter2++))
done

#another interation variable for a loop
intIter3=0

while [ "$intIter3"  -lt "$intlength" ];
do
#getting software package name
strSP=$(echo ${strSoftware} | jq -r .[${intIter}].install)
#checking version of software package installed and outputting it to log file
strVer=$(apt show ${strSP})
echo ${strVer} >> "Version.txt"
strVersion=$(grep -h "Version" Version.txt)
echo "Version Check - $strVersion" >> "configurationLogs/$2.log"

((intIter3++))
done

strfinalURL=$(curl "https://www.swollenhippo.com/ServiceNow/systems/devTickets/completed.php?TicketID=$2" | jq -r .outcome )
echo $strfinalURL >> "configurationLogs/$2.log"

strfinishdate=Date +"%d-%b-%Y"

echo "Completion Date: $strfinishdate " >> "configurationLogs/$2.log"



