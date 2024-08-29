#!/bin/bash

# Default email address
EMAIL="tanuedu128@gmail.com"

# Usage function
usage() {
  echo "Usage: $0 -d <domain_name> [-e <email_address>]"
  exit 1
}

# Parse command-line arguments
while getopts ":d:e:" opt; do
  case ${opt} in
    d )
      DOMAIN=$OPTARG
      ;;
    e )
      EMAIL=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Ensure domain is provided
if [ -z "$DOMAIN" ]; then
  echo "Domain name is required."
  usage
fi

# Check if Certbot is installed
if ! command -v certbot &> /dev/null; then
  echo "Certbot not found, installing..."
  sudo apt update
  sudo apt install -y certbot python3-certbot-nginx
else
  echo "Certbot is already installed"
fi

# Generate SSL certificate
if sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect; then
  echo "Certificate for $DOMAIN created successfully"
else
  echo "Failed to create certificate for $DOMAIN"
  exit 1
fi

# Test NGINX configuration and reload
if sudo nginx -t; then
  sudo systemctl reload nginx
  echo "NGINX reloaded successfully"
else
  echo "NGINX configuration test failed"
  exit 1
fi

# Setup auto-renewal
if sudo systemctl enable certbot.timer && sudo systemctl start certbot.timer; then
  echo "Auto-renewal setup completed"
else
  echo "Failed to set up auto-renewal"
  exit 1
fi

echo "SSL setup complete for $DOMAIN"
