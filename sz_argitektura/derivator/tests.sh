spec1=$(./derivate.sh 'x^(8+(5^2+x^3^2^26))*x^2+x^2^2^5')
if [ spec1="Result: add/sub" ]; then
    echo "1. ok"
else
    echo "1. error"
fi