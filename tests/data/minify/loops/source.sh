echo "while loop"
i=0
while [[ $i -lt 5 ]]
do
  echo $i
  i=$(( $i + 1 ))
done

echo "for loop"
for i in {0..4}
do
  echo $i
done

echo "until loop"
i=0
until [[ $i -ge 5 ]]
do
  echo $i
  i=$(( $i + 1 ))
done

echo "select"
select option in option1 option2
do
  echo $option
done