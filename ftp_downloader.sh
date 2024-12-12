#!/bin/bash

# Script to download files from an FTP server
# Usage: ./ftp_downloader.sh FTP_URL OUTPUT_DIR

# Check if the required arguments are provided
if [ "$#" -lt 2 ]; then
    echo "ERROR : required arguments are provided!"
    exit 1
fi

# Assign command-line arguments to variables
FTP_URL=$1
OUTPUT_DIR=$2

# Prompt user for FTP credentials
read -p "Enter username: " USER
read -s -p "Enter password: " PASSWORD
echo

# Ensure the output directory exists
mkdir -p "${OUTPUT_DIR}"

# Fetch the list of files from the FTP server
echo "Fetching file list from ${FTP_URL}..."
FILE_LIST=$(curl --user "${USER}:${PASSWORD}" --silent --list-only "${FTP_URL}")

if [ $? -ne 0 ]; then
    echo "Failed to retrieve file list from ${FTP_URL}. Check your credentials or the URL."
    exit 1
fi

# Download each file
for FILE in ${FILE_LIST}; do
    echo "Downloading ${FILE} from ${FTP_URL}..."
    curl --user "${USER}:${PASSWORD}" --fail --silent --show-error \
         --output "${OUTPUT_DIR}/${FILE}" \
         "${FTP_URL}/${FILE}"

    # Check if the download succeeded
    if [ $? -eq 0 ]; then
        echo "${FILE} downloaded successfully."
    else
        echo "Failed to download ${FILE}."
        exit 1
    fi

done

echo "All files processed. Files are in ${OUTPUT_DIR}."
