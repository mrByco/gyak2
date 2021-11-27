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

DoExpressionAnalizerLoop() {
  
    if [ "${expr:$i:1}" = "(" ]; then
      Pranteches=$(($Pranteches+1))
    elif [ "${expr:$i:1}" = ")" ]; then
      Pranteches=$(($Pranteches-1))
    elif [ "${expr:$i:1}" = "^" ]; then
      Exponent=$(($Exponent+1))
    fi

    if [[ "${expr:$i:1}" =~ [-\/\+\)\×] ]] && [ $Exponent -gt 0 ] ; then
      RawExponent=1
      TrackBackPrantCount=$Pranteches
      TrackBackExponentCount=$Exponent

      for (( j=$i; j>0; j-- )); do

        if [[ "${expr:$j:1}" =~ [-\/\+\)\×] ]] && [ $j -lt $i ]; then
          RawExponent=0
        fi
        if [ "${expr:$j:1}" = "(" ]; then
          TrackBackPrantCount=$(($TrackBackPrantCount-1))
          RawExponent=0
        elif [ "${expr:$j:1}" = ")" ]; then
          TrackBackPrantCount=$(($TrackBackPrantCount+1))
        elif [ "${expr:$j:1}" = "^" ] && [ ${expr:$(($j+1)):1} = "(" ] && [ $TrackBackPrantCount = $Pranteches ]; then
          RawExponent=1
          Exponent=$(($Exponent-1))
        elif [ $RawExponent -eq 1 ] && [ "${expr:$j:1}" = "^" ]; then
          Exponent=$(($Exponent-1))
        fi
        if [ $Exponent -eq 0 ]; then
          break
        fi
      done
      
    fi
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
  inner_expr=$(echo $1 | grep -oP "^(-?([0-9]*))?$2\(.+\)$" | grep -oP "\((.*)\)")
  export prefix
  export prefix_negative
  export inner_expr
}

GetDeriationType(){
  expr=$1
  Pranteches=0
  Exponent=0
  # 5: +- 3: / 2: × 1: chain
  ExprType=1

  for (( i=0; i<${#1}; i++ )); do
    DoExpressionAnalizerLoop
    # echo "${expr:$i:1}"

    if [ $Exponent = 0 ] && [ $Pranteches = 0 ]; then
      if [[ ${expr:$i:1} = [-+] ]]; then
        ExprType=$(($ExprType>5 ? $ExprType : 5))
      elif [[ ${expr:$i:1} = [\/] ]]; then
        ExprType=$(($ExprType>3 ? $ExprType : 3))
      elif [[ ${expr:$i:1} = [\*] ]]; then
        ExprType=$(($ExprType>2 ? $ExprType : 2))
      fi
    fi
  done
  
  echo $ExprType
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

  # SIN
  elif [[ $1 =~ ^(-?([0-9]*))?sin\(.+\)$ ]]; then
        ExtractParams $1 sin
        echo "$(($prefix*$prefix_negative))cos$inner_expr"
        
  # COS
  elif [[ $1 =~ ^(-?([0-9]*))?cos\(.+\)$ ]]; then
        ExtractParams $1 cos
        echo "$(($prefix*$prefix_negative*-1))sin$inner_expr"

  # TAN
  elif [[ $1 =~ ^(-?([0-9]*))?tan\(.+\)$ ]]; then
        ExtractParams $1 tan
        echo "$(($prefix*$prefix_negative))/(cos$inner_expr^2)"

  # COT
  elif [[ $1 =~ ^(-?([0-9]*))?cot\(.+\)$ ]]; then
        ExtractParams $1 cot
        echo "$(($prefix*$prefix_negative*-1))/(sin$inner_expr^2)"

  # ARCSIN
  elif [[ $1 =~ ^(-?([0-9]*))?arcsin\(.+\)$ ]]; then
        ExtractParams $1 arcsin
        echo "$(($prefix*$prefix_negative))/root(2,1-$inner_expr^2)"

  # ARCCOS
  elif [[ $1 =~ ^(-?([0-9]*))?arccos\(.+\)$ ]]; then
        ExtractParams $1 arccos
        echo "$(($prefix*$prefix_negative*-1))/root(2,1-$inner_expr^2)"
        
  # ARCTAN
  elif [[ $1 =~ ^(-?([0-9]*))?arctan\(.+\)$ ]]; then
        ExtractParams $1 arctan
        echo "$(($prefix*$prefix_negative))/1+$inner_expr^2"

  # ARCCOT
  elif [[ $1 =~ ^(-?([0-9]*))?arccot\(.+\)$ ]]; then
        ExtractParams $1 arccot
        echo "$(($prefix*$prefix_negative*-1))/1+$inner_expr^2"

# SINH
  elif [[ $1 =~ ^(-?([0-9]*))?sinh\(.+\)$ ]]; then
        ExtractParams $1 sinh
        echo "$(($prefix*$prefix_negative))cosh$inner_expr"

# COSH
  elif [[ $1 =~ ^(-?([0-9]*))?cosh\(.+\)$ ]]; then
        ExtractParams $1 cosh
        echo "$(($prefix*$prefix_negative))sinh$inner_expr"  

# TANH
  elif [[ $1 =~ ^(-?([0-9]*))?tanh\(.+\)$ ]]; then
        ExtractParams $1 tanh
        echo "$(($prefix*$prefix_negative))/(cosh$inner_expr^2)"
        
# COTH
  elif [[ $1 =~ ^(-?([0-9]*))?coth\(.+\)$ ]]; then
        ExtractParams $1 coth
        echo "$(($prefix*$prefix_negative*-1))/(sinh$inner_expr^2)"

# ARSINH
  elif [[ $1 =~ ^(-?([0-9]*))?arsinh\(.+\)$ ]]; then
        ExtractParams $1 arsinh
        echo "$(($prefix*$prefix_negative))/root(2,($inner_expr^2)+1)"

# ARCOSH
  elif [[ $1 =~ ^(-?([0-9]*))?arcosh\(.+\)$ ]]; then
        ExtractParams $1 arcosh
        echo "$(($prefix*$prefix_negative))/root(2,($inner_expr^2)-1)"

# ARTANH
  elif [[ $1 =~ ^(-?([0-9]*))?artanh\(.+\)$ ]]; then
        ExtractParams $1 artanh
        echo "$(($prefix*$prefix_negative))/1-$inner_expr^2"

# ARCOTH
  elif [[ $1 =~ ^(-?([0-9]*))?arcoth\(.+\)$ ]]; then
        ExtractParams $1 arcoth
        echo "$(($prefix*$prefix_negative))/1-$inner_expr^2"


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
  # x^x+1
  # 4func(x+1)
  type=$(GetDeriationType $1)

  if [ $type -eq 5 ]; then
    type="add/sub"
  elif [ $type -eq 3 ]; then
    type="div"
  elif [ $type -eq 2 ]; then
    type="multiply"
  elif [ $type -eq 1 ]; then
    type="chain"
  fi
  
  echo $type
  
  #DerivateSingle $1
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