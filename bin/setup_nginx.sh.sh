#!/bin/bash

# Default values
protocol="http"  # Default protocol is HTTP

# Usage function
usage() {
  echo "Usage: $0 -n <server_name> -p <server_port> [-t http|https]"
  exit 1
}

# Parse command-line arguments
while getopts ":n:p:t:" opt; do
  case ${opt} in
    n )
      server_name=$OPTARG
      ;;
    p )
      server_port=$OPTARG
      ;;
    t )
      protocol=$OPTARG
      if [[ "$protocol" != "http" && "$protocol" != "https" ]]; then
        echo "Invalid protocol specified. Use 'http' or 'https'."
        usage
      fi
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

# Ensure required arguments are provided
if [ -z "$server_name" ] || [ -z "$server_port" ]; then
  echo "Missing required arguments."
  usage
fi

# Update the package list
sudo apt update

# Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
  echo "Nginx not found. Installing Nginx..."
  sudo apt install -y nginx
fi

# Unlink default site, if it exists
if [ -L /etc/nginx/sites-enabled/default ]; then
  sudo unlink /etc/nginx/sites-enabled/default
fi

# Check if a configuration for the same server name already exists
if [ -f /etc/nginx/sites-available/$server_name ]; then
  echo "Removing existing configuration for $server_name..."
  sudo rm /etc/nginx/sites-available/$server_name
  sudo rm /etc/nginx/sites-enabled/$server_name 2>/dev/null
fi

# Create new Nginx server configuration
sudo tee /etc/nginx/sites-available/$server_name > /dev/null <<EOL
server {
    server_name $server_name;

    location / {
        proxy_pass $protocol://localhost:$server_port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Link the configuration to sites-enabled
sudo ln -s /etc/nginx/sites-available/$server_name /etc/nginx/sites-enabled/

# Test the Nginx configuration for syntax errors
sudo nginx -t

# Reload Nginx to apply the changes
if [ $? -eq 0 ]; then
  sudo nginx -s reload
  echo "Nginx configuration for $server_name successfully reloaded."
else
  echo "Nginx configuration test failed. Please check the configuration."
fi
