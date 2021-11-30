#!/bin/bash


RED='\033[0;31m'
NC='\033[0m'

Help() {
    # Display Help
    echo "Description for the derivation function in bash script"
    echo
    echo "Syntax: ./derivate [-h] sin^2((x^2-3x-5)/4)*cos(x^3-1)"
    echo "options:"
    echo "      -h     Print this Help."
    echo
}



while getopts ':h' option; do
    case $option in
        h)
            Help
            exit
        ;;
    esac
done
result=$(./derivate_complex.sh "$1")
# result=$(DerivateSingle $1)
echo "Result:  $result"