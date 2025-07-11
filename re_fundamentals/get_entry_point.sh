#!/bin/bash

# Import messages.sh functions
source ./messages.sh

# Check argument count
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ELF_file>"
    exit 1
fi

file_name="$1"

# Check if file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' not found."
    exit 1
fi

# Check if file is ELF
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# Extract Magic Number (first 16 bytes of ELF header)
magic_number=$(xxd -p -l 16 "$file_name" | sed 's/../& /g')

# Extract Class (32 or 64 bit)
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2, $3}')

# Extract Byte Order (Endianess)
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3}')

# Extract Entry Point Address
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Call the display function from messages.sh
display_elf_header_info
