#!/bin/bash


RED='\033[0;31m'
NC='\033[0m'

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
    
    # if [ $Pranteches -eq 0 ] && [ $Exponent -eq 0 ]; then #  &&  ]
    #   printf -- ${RED}"${expr:$i:1}"
    # else
    #   printf -- ${NC}"${expr:$i:1}"
    # fi
    # printf -- ${NC}
}

AppendToLast() {
    local -n arr=$1
    lastIndex=$((${#arr[@]}-1))
    if [ $lastIndex -eq -1 ];then
        lastIndex=0
    fi
    arr[$lastIndex]="${arr[$lastIndex]}$2"
}

AnalizeExpression(){
    expr=$1
    Pranteches=0
    Exponent=0
    
    addSubtractSegments=()
    multiplySegments=()
    divisionSegments=()
    
    chainContent=''
    chainState=0
    
    lastChar='none'
    #
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
        
        
        # printf "$lastChar"
        
        
    done
    # printf "cc($chainContent)"
    
    # for element in ${multiplySegments[@]}; do
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

DerivateComplex(){
    
    AnalizeExpression "$1"
    
    # echo "derivating: $1, type: $type"
    if [ $type -eq 4 ]; then
        type="add/sub"
        first=1
        for element in ${addSubtractSegments[@]}; do
            if [ $first -eq 0 ];then
                printf +
            fi
            printf -- "$(DerivateComplex $element)"
            first=0
        done
        elif [ $type -eq 5 ]; then
        printf -- "$(DerivateComplex ${divisionSegments[0]})/$(DerivateComplex ${divisionSegments[1]})"
        type="div"
        elif [ $type -eq 2 ]; then
        
        for i in ${!multiplySegments[@]}; do
            if [ $i -ne 0 ]; then
                printf -- "+"
            fi
            for j in ${!multiplySegments[@]}; do
                if [ $j -ne 0 ] && [ "$j" -lt "$((${#multiplySegments[@]}))" ]; then
                    printf -- "*"
                fi
                if [ $i -eq $j ]; then
                    printf -- "$(./derivate_complex.sh ${multiplySegments[$j]})"
                else
                    printf -- "${multiplySegments[$j]}"
                fi
            done
        done
        type="multiply"
        elif [ $type -eq 1 ]; then
        if [[ $chainContent =~ ^-?[0-9]*$ ]] || [[ $chainContent =~ ^x$ ]]; then
            printf -- "$(./derivate_single.sh $1)"
        else
            printf -- "$(./derivate_single.sh $1)*$(DerivateComplex $chainContent)"
        fi
        type="chain"
        elif [ $type -eq 0 ]; then
        type="single"
        echo "$(./derivate_single.sh $1)"
    fi
    # echo $type
    # echo c$chainContent
    
    
    #"$(./derivate_single.sh $1)" $1
}

echo $(DerivateComplex $1)

# bugs
#
#
#
# https://users.iit.uni-miskolc.hu/~szkovacs/SzgArch/script_feladatok.html

# 19. Deriválás (2 fő)
# Írj programot, ami argumentumban megadott kifejezésnek kiszámolja a deriváltját. A program tudja kezelni az alábbi műveleteket, fogalmakat: osztás, szorzás, polinomok, sin, cos, zárójelezés. Pl:
#      $>deriv sin^2((x^2-3x-5)/4)

#      $>0.5*sin((x^2-3x-5)/4)*(2x-6)

#      $>deriv sin^2((x^2-3x-5)/4)*cos(x^3-1)