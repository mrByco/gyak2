#!/bin/bash

Help() {
  # Display Help
  echo "Description for the derivation function in bash script"
  echo
  echo "Syntax: ./derivate [-h] sin^2((x^2-3x-5)/4)*cos(x^3-1)"
  echo "options:"
  echo "      -h     Print this Help."
  echo
}

IsSingleDerivable(){
  # RegExes to decide if it is a single derivable
  # $1 should be the value to derivate
  echo ""
  echo ""
  return 0
}

DerivateSingle() {
  # Executes a single non composite subderivation
  if (($1 <= 1)); then
    echo 1
  else
    last=$(derivate_single $(($1 - 1)))
    echo $(($1 * last))
  fi
}

DerivateComplex(){
   # Split a complex composite derivation to multiple subderivation
   # Implement addition, subtraction, multiplication, division, and chain rule
  echo
  echo
}

DerivationLoop(){
  echo $1
  #if [ IsSingleDerivable ]
  #then
  #  return DerivateSingle
  #fi
}

while getopts ':h' option; do
  case $option in
  h)
    Help
    exit
    ;;
  *)
    echo "Wrong usage"
    Help
    exit
    ;;
  esac
done

result=$(DerivationLoop $1)
echo "Result: " $result
read
