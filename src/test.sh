#!/bin/bash

# Declare an array named 'myArray'
myArray=(element1 element2 element3)

# Print the entire array
echo "Elements of myArray: ${myArray[@]}"

# Access individual elements of the array
echo "First element: ${myArray[0]}"
echo "Second element: ${myArray[1]}"
echo "Third element: ${myArray[2]}"


echo "Generate Random Number"
shuf -i 0-4 -n 1
