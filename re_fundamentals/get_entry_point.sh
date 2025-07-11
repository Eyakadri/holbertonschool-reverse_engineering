#!/bin/bash

source ./messages.sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <elf_file>"
  exit 1
fi

file_name="$1"

if [ ! -f "$file_name" ]; then
  echo "Error: File '$file_name' not found."
  exit 1
fi

if ! file "$file_name" | grep -q ELF; then
  echo "Error: '$file_name' is not a valid ELF file."
  exit 1
fi

magic_number=$(head -c16 "$file_name" | od -An -tx1 | tr -s ' ' | sed 's/^ //; s/ $//')
class=$(readelf -h "$file_name" | awk '/Class:/ {print $2}')
byte_order=$(readelf -h "$file_name" | grep 'Data:' | sed 's/.*,//; s/^[ \t]*//')
entry_point_address=$(readelf -h "$file_name" | awk '/Entry point address:/ {print $4}')

display_elf_header_info
