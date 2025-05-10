#!/bin/bash

CONTRACT=$1

# Get the deployed bytecode
BYTECODE=$(forge inspect $CONTRACT deployedBytecode)

# Remove the "0x" prefix and calculate the byte size
BYTECODE_SIZE=$((${#BYTECODE} / 2))

echo "Deployment size of $CONTRACT: $BYTECODE_SIZE bytes"
