#!/bin/bash

# Set the Instance ID and path to the .env file
INSTANCE_ID="gke-test-test-pool-f2664938-9x0j"

# Retrieve the public IP address of the specified EC2 instance
#ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
ipv4_address=$(gcloud compute instances describe $INSTANCE_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone="us-central1-c")
# Path to the .env file
file_to_find="../frontend/.env.docker"

# Check the current VITE_API_PATH in the .env file
current_url=$(cat $file_to_find)

# Update the .env file if the IP address has changed
if [[ "$current_url" != "VITE_API_PATH=\"http://${ipv4_address}:31100\"" ]]; then
    if [ -f $file_to_find ]; then
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" $file_to_find
    else
        echo "ERROR: File not found."
    fi
fi
