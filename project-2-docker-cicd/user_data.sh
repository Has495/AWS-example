#!/bin/bash

set -x
set -e

echo "Starting Project 2 setup"

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

for i in {1..3}; do
    echo "Docker installation attempt $i of 3"

    if sudo dnf install -y docker; then
        echo "Docker installed successfully"
        break
    else
        echo "Docker installation failed"

        if [ "$i" -eq 3 ]; then
            echo "All Docker installation attempts failed"
            exit 1
        fi

        sleep 5
    fi
done

systemctl enable --now docker

if sudo docker info; then
    echo "Docker is running"
else
    echo "Docker is not running"
    exit 1
fi