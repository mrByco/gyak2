tests=( "x^(8+(5^2+x^3^2^26))*x^2+x^2^2^5" "add/sub" )

i=0

for t in ${tests[@]}; do
    
    # echo $t
    if [ $(($i%2)) -eq 1 ]; then
        spec1=$(./derivate.sh $subject)
        # echo $spec1
        if [ spec1 == $t ]; then
            echo "$(($i)). ok  -  $subject  -> $spec1"
        else
            echo "$(($i)). error - $subject -> $t expected but got $spec1"
        fi
    else
        subject=$t
    fi
    i=$(( $i+1 ))
    # echo $i
done

# spec1=$(./derivate.sh )
# if [ spec1="Result: add/sub" ]; then
#     echo "1. ok"
# else
#     echo "1. error"
# fi