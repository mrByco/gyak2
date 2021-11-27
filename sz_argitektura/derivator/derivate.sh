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


# Extracts params of a -4sin(x) or any other function to prefix, prefix_negative, and inner content
# $1 should be the expression, $2 the name of the function
ExtractParams(){
  prefix=$(echo $1 | (grep -oP "(-)?[0-9]+$2" || echo 1) | grep -oP "[0-9]+")
  if [[ $1 =~ ^-[0-9]*.*$ ]]; then
    prefix_negative=-1
  else
    prefix_negative=1
  fi
  inner_expr=$(echo $1 | grep -oP "^(-?([0-9]+))?$2\(.+\)$" | grep -oP "\((.*)\)")
  export prefix
  export prefix_negative
  export inner_expr
}

DerivateSingle() {
  # Executes a single non composite subderivation oiasjdolkajsdlk

  # 54x^5, -231x^5342, 4x^-234234
  if [[ $1 =~ ^(-?([0-9]*))?x\^[0-9]*$ ]]; then
        prefix=$(echo $1 | (grep -oP "(-)?[0-9]+x" || echo 1) | grep -oP "[0-9]+")
        if [[ $1 =~ ^-[0-9]*.*$ ]]; then
            prefix_negative=-1
          else
            prefix_negative=1
        fi
        exponent=$(echo $1 | grep -oP "\^(-)?[0-9]*" | grep -oP "(-)?[0-9]*")
        echo $prefix_negative
        if [[ $exponent == 2 ]]; then
          echo "$(($prefix_negative*$prefix*$exponent))"x
        else
        # shellcheck disable=SC2140
          echo "$(($prefix_negative*$prefix*$exponent))"x^"$(("$exponent"-1))"
        fi

  # sin(x), sin(x + 54/x) sin(blablabla) 
  elif [[ $1 =~ ^(-?([0-9]+))?sin\(.+\)$ ]]; then
        ExtractParams $1 sin
        echo "$(($prefix*$prefix_negative))cos$inner_expr"
        

  # cos(x), cos(x + 54/x) cos(blablabla)
  elif [[ $1 =~ ^(-?([0-9]+))?cos\(.+\)$ ]]; then
        ExtractParams $1 cos
        echo "$(($prefix*$prefix_negative*-1))sin$inner_expr"

  
  # tan(x), tan(x + 54/x) tan(blablabla)
  elif [[ $1 =~ ^(-?([0-9]+))?tan\(.+\)$ ]]; then
        ExtractParams $1 tan
        echo "$(($prefix*$prefix_negative))/(cos$inner_expr)^2"

  
  # cos(x), cos(x + 54/x) cos(blablabla) 
  elif [[ $1 =~ ^(-?([0-9]+))?arcsin\(.+\)$ ]]; then
        ExtractParams $1 arcsin
        echo "$(($prefix*$prefix_negative))/root(2,1-$inner_expr^2)"


  # log(a,x)
  elif [[ $1 =~ ^log\([2-9]+,x\)$ ]]; then
        prefix=$(echo $1 | grep -oP "[2-9]+")
        echo "1/(x*ln$prefix)"

  # lnx
  elif [[ $1 =~ lnx ]]; then
        echo "1/x"
  
  # e^x
  elif [[ $1 =~ e\^x$ ]]; then
        echo "e^x"

  # a^x
  elif [[ $1 =~ [2-9]+\^x$ ]]; then
        prefix=$(echo $1 | grep -oP "[2-9]+")
        echo "$prefix^x*ln$prefix"

  # constant
  elif [[ $1 =~ ^-?[0-9]+$ ]]; then
        echo 0

  # invalid entry
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
  esac
done

result=$(DerivationLoop $1)
echo "Result: " $result
