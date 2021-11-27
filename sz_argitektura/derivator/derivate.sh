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

DerivateSingle() {
  # Executes a single non composite subderivation oiasjdolkajsdlk

  

  # x^5, x^5342, x^-234234
  if [[ $1 =~ ^([a-z]\^-?[0-9]*)$ ]]; then
      exponent=$(echo $1 | grep -oP "\-*[0-9]+")
      if [[ $exponent == 2 ]]; then
        echo "2x"
      else
        # shellcheck disable=SC2140
        echo "$exponent"x^"$(("$exponent"-1))"
      fi
  # 54x^5, -231x^5342, 4x^-234234
  elif [[ $1 =~ ^(-?[0-9]+)?[a-z]\^-?[0-9]*$ ]]; then
        prefix=$(echo $1 | grep -oP "(-)?[0-9]*x" | grep -oP "(-)?[0-9]*")
        exponent=$(echo $1 | grep -oP "\^(-)?[0-9]*" | grep -oP "(-)?[0-9]*")
        if [[ $exponent == 2 ]]; then
          echo "$(($prefix*$exponent))"x
        else
        # shellcheck disable=SC2140
          echo "$(($prefix*$exponent))"x^"$(("$exponent"-1))"
        fi
  # s
  elif [[ $1 =~ ^(-?[0-9]+)?[a-z]\^-?[0-9]*$ ]]; then
        prefix=$(echo $1 | grep -oP "-?[0-9]*x")
        exponent=$(echo $1 | grep -oP "\^-*[0-9]*" | grep -oP "\-*[0-9]*")
        echo "$($prefix * $exponent)"x^"$(("$exponent"-1))"
  else
      echo "Not implemented"
  fi
}

DerivateComplex(){
   # Split a complex composite derivation to multiple subderivation
   # Implement addition, subtraction, multiplication, division, and chain rule
  echo
  echo
}

DerivationLoop(){
  DerivateSingle $1
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
