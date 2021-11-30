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

DoExpressionAnalizerLoop() {
  
    if [ "${expr:$i:1}" = "(" ]; then
      Pranteches=$(($Pranteches+1))
    elif [ "${expr:$i:1}" = ")" ]; then
      Pranteches=$(($Pranteches-1))
    elif [ "${expr:$i:1}" = "^" ]; then
      Exponent=$(($Exponent+1))
    fi

    if [[ "${expr:$i:1}" =~ [-\/\+\)\*] ]] && [ $Exponent -gt 0 ] ; then
      RawExponent=1
      TrackBackPrantCount=$Pranteches
      TrackBackExponentCount=$Exponent
      

      for (( j=$i; j>0; j-- )); do

        if [[ "${expr:$j:1}" =~ [-\/\+\)\*] ]] && [ $j -lt $i ]; then
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
  
      if [ $Pranteches -eq 0 ] && [ $Exponent -eq 0 ]; then #  &&  ]
        printf ${RED}"${expr:$i:1}"
      else
        printf ${NC}"${expr:$i:1}"
      fi
      # printf ${NC}
}

AppendToLast() {
  local -n arr=$1
  lastIndex=$((${#arr[@]}-1))
  if [ $lastIndex -eq -1 ];then
    lastIndex=0 
  fi
  arr[$lastIndex]="${arr[$lastIndex]}$2"
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

  addSubtractSegments=()
  multiplySegments=()
  divisionSegments=()

  chainContent=''
  chainState=0

  lastChar='none'

  # 4: +- 5: / 2: × 1: chain 0: simple
  type=0

  for (( i=0; i<${#1}; i++ )); do
    DoExpressionAnalizerLoop


    if [ $Exponent = 0 ] && [ $Pranteches = 0 ]; then
      if [[ ${expr:$i:1} = [+] ]]; then
        type=$(($type>4 ? $type : 4))
      elif [[ ${expr:$i:1} = [-] ]] && [ $i -ne 0 ]; then
        type=$(($type>4 ? $type : 4))
      elif [[ ${expr:$i:1} = [\/] ]]; then
        type=$(($type>5 ? $type : 5))
      elif [[ ${expr:$i:1} = [\*] ]]; then
        type=$(($type>2 ? $type : 2))
      fi
    fi

    
    if [ $Pranteches -eq 0 ] && [ $Exponent -eq 0 ]  && ! [[ ${expr:$i:1} =~ [-\/\+\*] ]]; then
      if [ "$lastChar" == "+" ]; then
          addSubtractSegments+=(${expr:$i:1})
          
          AppendToLast divisionSegments +${expr:$i:1}
          AppendToLast multiplySegments +${expr:$i:1}

          # printf ${RED}$lastChar
      elif [ "$lastChar" == "-" ]; then
          addSubtractSegments+=(-${expr:$i:1})
          
          AppendToLast divisionSegments -${expr:$i:1}
          AppendToLast multiplySegments -${expr:$i:1}
          
          # printf ${RED}$lastChar
      elif [ "$lastChar" == "*" ]; then
          multiplySegments+=(${expr:$i:1})

          AppendToLast addSubtractSegments *${expr:$i:1}
          AppendToLast divisionSegments *${expr:$i:1}
      elif [ "$lastChar" == "/" ]; then
          if [ ${#divisionSegments[@]} -lt 2 ]; then
            divisionSegments+=(${expr:$i:1})
          else
            AppendToLast divisionSegments /${expr:$i:1}
          fi
          AppendToLast addSubtractSegments /${expr:$i:1}
          AppendToLast multiplySegments /${expr:$i:1}
      else
          # Bash version 4.3
          AppendToLast addSubtractSegments ${expr:$i:1}
          AppendToLast divisionSegments ${expr:$i:1}
          AppendToLast multiplySegments ${expr:$i:1}
      fi
    elif ! [[ ${expr:$i:1} =~ [-\/\+*] ]] || [ $chainState -eq 1 ]; then
          # Bash version 4.3
        AppendToLast addSubtractSegments ${expr:$i:1}
        AppendToLast divisionSegments ${expr:$i:1}
        AppendToLast multiplySegments ${expr:$i:1}
    fi
    lastChar=${expr:$i:1}


    if ([ $Pranteches -gt 0 ] || [ $Exponent -gt 0 ])  && [ $chainState -lt 2 ]; then
      if [ $chainState -eq 0 ]; then
        chainState=1
      else
        chainContent+="${expr:$i:1}"
        type=$(($type>1 ? $type : 1))
        # printf ${expr:$i:1}
      fi
    fi
    if [ $Pranteches -eq 0 ] && [ $Exponent -eq 0 ]  && [ $chainState -eq 1 ]; then
      chainState=2
    fi


    # printf "$lastChar"


  done
  # printf "cc($chainContent)"

  # for element in ${addSubtractSegments[@]}; do
  #   echo " $element"
  # done

  # Pranteches=0
  # Exponent=0
  # lastChar='none'
  # for (( i=0; i<${#1}; i++ )); do
  #   DoExpressionAnalizerLoop
  #   lastChar=${expr:$i:1}
  # done

  export addSubtractSegments
  export multiplySegments
  export divisionSegments

  export chainContent
  export chainState

  export type
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
  elif [[ $1 =~ ^log\([0-9]+,x\)$ ]]; then
        prefix=$(echo $1 | grep -oP "[0-9]+")
        echo "1/(x*ln$prefix)"

  # lnx
  elif [[ $1 =~ lnx ]]; then
        echo "1/x"
  
  # e^x
  elif [[ $1 =~ e\^x$ ]]; then
        echo "e^x"

  # a^x
  elif [[ $1 =~ [0-9]+\^x$ ]]; then
        prefix=$(echo $1 | grep -oP "[0-9]+")
        echo "$prefix^x*ln$prefix"
  
  # x^x
  # elif [[ $1 =~ [0-9]+\^x$ ]]; then
  #       prefix=$(echo $1 | grep -oP "[0-9]+")
  #       echo "$prefix^x*ln$prefix"

  # constant
  elif [[ $1 =~ ^-?[0-9]+$ ]]; then
        echo 0

  # ax
  elif [[ $1 =~ ^\-?[0-9]*x$ ]]; then
        prefix=$(echo $1 | grep -oP "\-?[0-9]" || echo 1)
        echo $prefix

  # invalid entry
  else
      echo "Not implemented ($1)"
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
  GetDeriationType "$1"
  
  echo "\nderivating: $1, type: $type\n" 
  if [ $type -eq 4 ]; then
    type="add/sub"
    first=1
    for element in ${addSubtractSegments[@]}; do
      if [ $first -eq 0 ];then 
        printf +
      fi
      printf -- "$(DerivationLoop $element)"
      first=0
    done
  elif [ $type -eq 5 ]; then
    printf -- "$(DerivationLoop ${divisionSegments[0]})/$(DerivationLoop ${divisionSegments[1]})"
    type="div"
  elif [ $type -eq 2 ]; then
    type="multiply"
  elif [ $type -eq 1 ]; then
    if [ chainContent == "x" ]; then
      printf -- "$(DerivateSingle $1)"
    else 
      printf -- "$(DerivateSingle $1)*$(DerivationLoop $chainContent)"
    fi
    type="chain"
  elif [ $type -eq 0 ]; then
    type="single"
    echo $(DerivateSingle $1)
  fi
  # echo $type
  # echo c$chainContent

  
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
result=$(DerivationLoop "$1")
# result=$(DerivateSingle $1)
echo "Result:  $result"