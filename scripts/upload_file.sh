#!/bin/bash

# Check if two arguments have been provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 -f <file_name> -p <serial_port>"
    exit 1
fi

# Assign arguments to variables
while getopts "f:p:" opt; do
    case $opt in
        f)
            file=$OPTARG
            ;;
        p)
            serial_port=$OPTARG
            ;;
        \?)
            echo "Usage: $0 -f <file_name> -p <serial_port>"
            exit 1
            ;;
    esac
done

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi

# Copy the file to the device using mpremote
mpremote connect $serial_port cp $file :

# Check if the previous command was successful
if [ $? -eq 0 ]; then
    echo "File '$file' successfully copied to the device on port '$serial_port'."
    mpremote connect $serial_port ls :
else
    echo "Error copying file '$file' to the device on port '$serial_port'."
    exit 1
fi