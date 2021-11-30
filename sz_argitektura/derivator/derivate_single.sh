#!/bin/bash

## DEPENDENCY OF DERIVATE.SH

Calculate(){
  echo $1 | bc
}

# $1 expression $2 function name
MatchFunctionRegex(){
    if [[ $1 =~ ^-?[0-9]*(\.[0-9])*($2)(\^\-?[0-9]*(\.[0-9]*)?)?\(.*\)$ ]]; then
    # if [[ $1 =~ .* ]]; then
        echo 1
    else
        echo 0
    fi
}

# Extracts params of a -4sin(x) or any other function to prefix, prefix_negative, and inner content
# $1 should be the expression, $2 the name of the function
ExtractParams(){
    firstPart=$(echo $1 | grep -oP "^-?[0-9]*(\.[0-9])*($2)(\^-?[0-9]+\.?([0-9])*)?\(")
    prefix=$(echo $firstPart | grep -oP "^-?[0-9]*(\.[0-9]+)*($2)" | grep -oP "[\-\.0-9]+")
    exponent=$(echo $firstPart | grep -oP "\^-?[0-9]+(\.[0-9])*\(" | grep -oP "[\-\.0-9]+")
    
    if [ $prefix == "-" ]; then
        prefix="-1"
    fi
    if [ $exponent == "-" ]; then
        exponent=-1
    fi

    prefix_prederivated=$(echo "$prefix*$exponent" | bc)
    inner_expr=$(echo $1 | grep -oP "^-?[0-9]*(\.[0-9])*($2)(\^-?[0-9]+\.?([0-9])*)?\(.+\)$" | grep -oP "\((.*)\)")
    export exponent
    export prefix
    export prefix_prederivated
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
        if [[ $exponent == 2 ]]; then
            echo "$(($prefix_negative*$prefix*$exponent))"x
        else
            # shellcheck disable=SC2140
            echo "$(($prefix_negative*$prefix*$exponent))"x^"$(("$exponent"-1))"
        fi
        # SIN -5sin^2(x)
        elif [ $(MatchFunctionRegex "$1" sin) == 1 ]; then  #[[ $1 =~ ^(-?([0-9]*))?sin\(.+\)$ ]]; then
        ExtractParams $1 sin
        if [ $exponent != 1 ]; then 
          echo "$(Calculate "$prefix*$exponent")$inner_expr" 
          else
          echo "$(($prefix))cos$inner_expr" 
        fi
        
        # COS
        elif [[ $1 =~ ^(-?([0-9]*))?cos\(.+\)$ ]]; then
        ExtractParams $1 cos
        echo "$(($prefix*-1))sin$inner_expr"
        
        # TAN
        elif [[ $1 =~ ^(-?([0-9]*))?tan\(.+\)$ ]]; then
        ExtractParams $1 tan
        echo "$(($prefix))/(cos$inner_expr^2)"
        
        # COT
        elif [[ $1 =~ ^(-?([0-9]*))?cot\(.+\)$ ]]; then
        ExtractParams $1 cot
        echo "$(($prefix*-1))/(sin$inner_expr^2)"
        
        # ARCSIN
        elif [[ $1 =~ ^(-?([0-9]*))?arcsin\(.+\)$ ]]; then
        ExtractParams $1 arcsin
        echo "$(($prefix))/root(2,1-$inner_expr^2)"
        
        # ARCCOS
        elif [[ $1 =~ ^(-?([0-9]*))?arccos\(.+\)$ ]]; then
        ExtractParams $1 arccos
        echo "$(($prefix*-1))/root(2,1-$inner_expr^2)"
        
        # ARCTAN
        elif [[ $1 =~ ^(-?([0-9]*))?arctan\(.+\)$ ]]; then
        ExtractParams $1 arctan
        echo "$(($prefix))/1+$inner_expr^2"
        
        # ARCCOT
        elif [[ $1 =~ ^(-?([0-9]*))?arccot\(.+\)$ ]]; then
        ExtractParams $1 arccot
        echo "$(($prefix*-1))/1+$inner_expr^2"
        
        # SINH
        elif [[ $1 =~ ^(-?([0-9]*))?sinh\(.+\)$ ]]; then
        ExtractParams $1 sinh
        echo "$(($prefix))cosh$inner_expr"
        
        # COSH
        elif [[ $1 =~ ^(-?([0-9]*))?cosh\(.+\)$ ]]; then
        ExtractParams $1 cosh
        echo "$(($prefix))sinh$inner_expr"
        
        # TANH
        elif [[ $1 =~ ^(-?([0-9]*))?tanh\(.+\)$ ]]; then
        ExtractParams $1 tanh
        echo "$(($prefix))/(cosh$inner_expr^2)"
        
        # COTH
        elif [[ $1 =~ ^(-?([0-9]*))?coth\(.+\)$ ]]; then
        ExtractParams $1 coth
        echo "$(($prefix*-1))/(sinh$inner_expr^2)"
        
        # ARSINH
        elif [[ $1 =~ ^(-?([0-9]*))?arsinh\(.+\)$ ]]; then
        ExtractParams $1 arsinh
        echo "$(($prefix))/root(2,($inner_expr^2)+1)"
        
        # ARCOSH
        elif [[ $1 =~ ^(-?([0-9]*))?arcosh\(.+\)$ ]]; then
        ExtractParams $1 arcosh
        echo "$(($prefix))/root(2,($inner_expr^2)-1)"
        
        # ARTANH
        elif [[ $1 =~ ^(-?([0-9]*))?artanh\(.+\)$ ]]; then
        ExtractParams $1 artanh
        echo "$(($prefix))/1-$inner_expr^2"
        
        # ARCOTH
        elif [[ $1 =~ ^(-?([0-9]*))?arcoth\(.+\)$ ]]; then
        ExtractParams $1 arcoth
        echo "$(($prefix))/1-$inner_expr^2"
        
        
        # log(a,x)arccos
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
        elif [[ $1 =~ x\^x|[0-9]+\^x ]]; then
        prefix=$(echo $1 | grep -oP "x|[0-9]+")
        echo "$prefix^x*ln$prefix"
        
        # x^x
        elif [[ $1 =~ ^-?[0-9]*(\.[0-9]*)?x\^.*$ ]]; then
        echo "Ez a kifejezés nem támogatott ($1)"
        
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
# echo $(MatchFunctionRegex "5sin(x)" sin)

DerivateSingle $1