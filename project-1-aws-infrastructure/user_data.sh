#!/bin/bash

set -x
set -e

echo "Starting Project 1 setup"

# Update software - 3 attempts
for i in {1..3}; do
    echo "Software update attempt $i of 3"

    if sudo dnf upgrade -y; then
        echo "Software update successful"
        break
    else
        echo "Update failed"

        if [ "$i" -eq 3 ]; then
            echo "All update attempts failed"
            exit 1
        fi

        sleep 5
    fi
done

# Install Nginx - 3 attempts
for i in {1..3}; do
    echo "Nginx installation attempt $i of 3"

    if sudo dnf install -y nginx; then
        echo "Nginx installed successfully"
        break
    else
        echo "Nginx installation failed"

        if [ "$i" -eq 3 ]; then
            echo "All Nginx installation attempts failed"
            exit 1
        fi

        sleep 5
    fi
done

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create website
sudo mkdir -p /usr/share/nginx/html

echo "Project 1 - AWS Cloud Engineer Portfolio" | sudo tee /usr/share/nginx/html/index.html

echo "Project 1 setup completed successfully"
