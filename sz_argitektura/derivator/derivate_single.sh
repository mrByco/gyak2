#!/bin/bash

# arrays

array=('a' 'b' '')

array[4653]+='hello'

for element in ${array[@]}; do
  echo $element
done