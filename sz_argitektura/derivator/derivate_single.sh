#!/bin/bash

## DEPENDENCY OF DERIVATE.SH

# $1 expression $2 function name
MatchFunctionRegex(){
    echo $1 $2
    # if [[ $1 =~ -?[0-9]*(\.[0-9])*($2)\^\-?[0-9]*(\.[0-9]*)?\(.*\) ]]; then
    if [[ $1 =~ .* ]]; then
      match=1
    else
      match=0
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
    export exponent
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
        if [[ $exponent == 2 ]]; then
            echo "$(($prefix_negative*$prefix*$exponent))"x
        else
            # shellcheck disable=SC2140
            echo "$(($prefix_negative*$prefix*$exponent))"x^"$(("$exponent"-1))"
        fi
        
        
        match=$(MatchFunctionRegex "$1" sin)
        echo d$match
        match="ok"
        echo matchis$match
        # SIN -5sin^2(x)
        elif [ "$match" == "ok" ]; then  #[[ $1 =~ ^(-?([0-9]*))?sin\(.+\)$ ]]; then
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