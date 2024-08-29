#!/bin/bash

# Usage function
usage() {
  echo "Usage: $0 <command> [options]"
  echo "Commands:"
  echo "  manage_server -n <server_name> -p <server_port> [-t http|https] [-e <email_address>]"
  echo "  setup_nginx -n <server_name> -p <server_port> [-t http|https]"
  echo "  setup_ssl -d <domain_name> [-e <email_address>]"
  exit 1
}

# Parse the main command
if [ -z "$1" ]; then
  usage
fi

command=$1
shift

case "$command" in
  manage_server)
    ./bin/manage_server.sh "$@"
    ;;
  setup_nginx)
    ./bin/setup_nginx.sh "$@"
    ;;
  setup_ssl)
    ./bin/setup_ssl.sh "$@"
    ;;
  *)
    echo "Invalid command: $command"
    usage
    ;;
esac
