#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <remote_user> <remote_host> <remote_password>"
    exit 1
fi

# Get the command-line arguments
REMOTE_USER=$1
REMOTE_HOST=$2
REMOTE_PASSWORD=$3

# List of services to check
services=(
    "node-manager"
    "duroslight-0"
    "duroslight-1"
    "cluster-manager"
    "upgrade-manager"
    "api-service"
    "lightbox-exporter"
    "discovery-service"
    "etcd"
    "gftl"
)

# List of ports to check
ports=(
    "SSH Access:22"
    "API Access:443"
    "ETCD:2379"
    "ETCD:2380"
    "Monitoring metrics:8090"
    "Monitoring metrics:443"
    "Nvme TCP:4420"
    "Nvme TCP (2numa1ip):4421"
    "Nvme Discovery:8009"
    "Lightbits replica traffic:22226"
    "Lightbits replica traffic (2numa1ip):22227"
    "cluster-manager debug:4000"
    "node-manager debug:4001"
    "discovery-service debug:6060"
    "duroslight debug (1numa):9180"
    "duroslight debug (2numa):9181"
)

# Function to check the status of a service on the remote host
check_service_status() {
    local service=$1
    sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "systemctl is-active --quiet $service"
    if [ $? -eq 0 ]; then
        echo "$service: RUNNING"
    else
        echo "$service: NOT RUNNING"
    fi
}

# Function to check if a port is open on the remote host
check_port_status() {
    local description=$1
    local port=$2
    port_open=$(sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "netstat -tuln | grep :$port")
    if [ -n "$port_open" ]; then
        echo "$description ($port): OPEN"
    else
        echo "$description ($port): CLOSED"
    fi
}

# Print header for services
echo -e "\nService Status:"
echo "===================="
echo -e "SERVICE\t\t\tSTATUS"
echo "===================="

# Iterate over the list of services and check their status
for service in "${services[@]}"; do
    check_service_status "$service"
done

# Print header for ports
echo -e "\nPort Status:"
echo "=============================="
echo -e "DESCRIPTION\t\tPORT\tSTATUS"
echo "=============================="

# Iterate over the list of ports and check their status
for port_info in "${ports[@]}"; do
    description=$(echo "$port_info" | cut -d: -f1)
    port=$(echo "$port_info" | cut -d: -f2)
    check_port_status "$description" "$port"
done

