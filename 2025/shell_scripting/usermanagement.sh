#!/bin/bash

<<info
This script uses different arguments to perform a task based on
user's input
e.g ./usermanagement.sh -c --> will create a user if it doesn't exist or else deny
./usermanagement.sh -d --> will delete a user if it exists or else deny
./usermanagment.sh -r --> will reset
./usermanagement.sh -l --> will list the users on the system
info


echo "Welcome to usermanagement program"

userinput="$1"
function userAccountManagement(){
        # Account creation
	if [ $userinput == "-c" ] || [$userinput == "--create" ]; then
		read -p "Enter username you wish to create: " username
		# check if user already exists
		usercheck=$(cat /etc/passwd | grep -q "^$username" | wc -l)
		if [ $usercheck -gt 0 ]; then
			echo "User already exists."
			exit
		else
			echo " user does not exist. Let's create the user"
			sudo useradd -m "$username" > /dev/null
			read -p "Enter password: " password
			echo -e "$password\n$password" | sudo passwd $username > /dev/null
			grep "^$username" /etc/passwd
			echo "User created successfully"
		fi

	# Account Deletion

	elif [ $userinput == "-d" ] || [$userinput == "--delete" ]; then
		read -p "Enter user name you wish to Delete: " username
		usercheck=$(cat /etc/passwd | grep -q "^$username" | wc -l )

		if [ $usercheck -gt 0 ]; then
			echo "User exists - Deleting user: $username with its home dir now....."
			sudo userdel -r $username > /dev/null
		else
			echo "User $username doesn't exist"
			exit 1
		fi

	# password reset
         elif [ $userinput == "-r" ] || [$userinput == "--reset"]; then
		 read -p "Enter user name you want to reset the password for: " username
		 usercheck=$(cat /etc/passwd | grep -q "^$username" | wc -l)

		 if [ $usercheck -gt 0 ]; then
			 echo "User exists"
			 read -p "Enter a new password for $username :" password
			 
			 echo -e "$password\n$password" | sudo passwd $username > /dev/null

			 echo "Password reset successfully"
		 else
			 echo "User $username does not exist"
			 exit 1
		 fi
	  # List User Accounts
	  elif [ "$1" == "-l" ] || [ "$1" == "--list" ]; then

		  (echo -e "Username\tUser ID\tHome Directory"; awk -F ':' '{print $1, $3, $6}' /etc/passwd) | column -t
	  
	  # Help Option
    	  elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
		  echo "User Account Management Script"
       		  echo "This script allows you to create, delete, list users, and reset user passwords."
        	  echo "Usage:"
        	  echo "  -c, --create    Create a new user account."
        	  echo "  -d, --delete    Delete an existing user account."
       		  echo "  -r, --reset     Reset the password of an existing user."
      		  echo "  -l, --list      List all available user accounts."
     		  echo "  -h, --help      Display this help message."

   	   # Invalid Option
   	   else
		   echo "Invalid option. Please use -h or --help for guidance. Example: sh AccountCreation.sh -h or ./AccountCreation.sh -h"
		   exit 1
fi

}
userinput=$1
userAccountManagement "$userinput"
