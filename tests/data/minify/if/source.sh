echo "CASE : condition; then"
if [[ 5 -eq 5 ]]; then
  echo "5 is equal to 5"
fi

echo "CASE : then on new line"
if [[ 5 -eq 5 ]]
then
  echo "5 is equal to 5"
fi

echo "CASE : if-elif"
if [[ 5 -ne 5 ]]
then
  echo "5 is not equal to 5"
elif [[ 6 -eq 6 ]]
then
  echo "6 is not equal to 6"
fi