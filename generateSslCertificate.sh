#! /bin/bash

# Creates an SSL Certificate.

# Download Certbot client
add-apt-repository ppa:certbot/certbot &> /dev/null

# Update package list to pick up new repository's package information
apt update

# Install Certbot
apt install -y python-certbot-apache

# Set the install directory
installDirectory="/opt/jamesm0rr1s/SSL-Certificate-Generator-for-Phishing"

# Set if using ufw
usingUfw=false

# Check if using ufw
if $usingUfw; then

	# Allow http through the firewall
	ufw allow http

fi

# Set the name of the file containing domains
fileOfDomans="domains.txt"

# Initialize the string of domains
domains=""

# Check if the file exists
if [ -f $installDirectory/$fileOfDomans ]; then

	# Loop through each line in the file
	while read domain; do

		# Check that the line is not blank
		if [ "$domain" != "" ]; then

			# Add the domain
			domains+=" -d $domain"

		fi

	done < $installDirectory/$fileOfDomans

# File of domains does not exist
else

	# Loop if the user does not enter anything
	while [ "$domains" == "" ]; do

		# Ask the user for a domain
		read -p "Please enter the domain: " domain

		# Check if the user did not enter anything
		if [ "$domain" == "" ];  then

			# Tell the user to enter a domain
			echo "A domain is required."

		# The user entered a domain
		else

			# Add the domain
			domains+=" -d $domain"

		fi

	done

fi

# Run Certbot
echo "A" | certbot --apache --register-unsafely-without-email $domains

# Check if using ufw
if $usingUfw; then

	# Deny http through the firewall if using
	ufw deny http

fi

# Renew the certificate
# certbot renew --quiet