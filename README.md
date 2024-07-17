# Remote Services and Ports Check Script

This script checks the status of specified services and ports on a remote host using SSH. It outputs the results in a table-like format for readability.

## Prerequisites

1. `sshpass` and `netstat` must be installed on the machine where you run the script.

2. Ensure the remote host has systemctl and netstat available.

Usage

1. Clone or download the script.

2. Make the script executable:

chmod +x LB_Services_Port_Check.sh

3. Run the script with command-line arguments:

./check_remote_services_and_ports.sh <remote_user> <remote_host> <remote_password>

Replace <remote_user>, <remote_host>, and <remote_password> with the appropriate SSH username, IP address, and password of the remote host.

e.g. ./check_remote_services_and_ports.sh myuser 192.168.1.100 mypassword

