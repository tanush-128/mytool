#!/bin/bash

# Usage function
usage() {
  echo "Usage: $0 -n <server_name> -p <server_port> [-t http|https] [-e <email_address>]"
  echo "       -n: Server name (required)"
  echo "       -p: Server port (required)"
  echo "       -t: Protocol, either 'http' or 'https' (default: http)"
  echo "       -e: Email address for SSL certificate (only required if using https)"
  exit 1
}

# Parse command-line arguments
while getopts ":n:p:t:e:" opt; do
  case ${opt} in
    n )
      server_name=$OPTARG
      ;;
    p )
      server_port=$OPTARG
      ;;
    t )
      protocol=$OPTARG
      ;;
    e )
      email=$OPTARG
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

# Set defaults
protocol=${protocol:-http}
email=${email:-tanuedu128@gmail.com}

# Call the script to set up the Nginx server configuration
./setup_nginx.sh -n "$server_name" -p "$server_port" -t "$protocol"

# If HTTPS is chosen, call the script to generate SSL certificates
if [ "$protocol" == "https" ]; then
  ./setup_ssl.sh -d "$server_name" -e "$email"
fi
