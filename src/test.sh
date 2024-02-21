#!/bin/bash

# Declare an array named 'myArray'
programming_languages=('Bash' 'Python' 'JavaScript' 'Ruby', 'Java')

# Print the entire array
echo "Elements of myArray: ${programming_languages[@]}"

# Guess the user's preferred language
echo "trying: ${programming_languages[$RANDOM % ${#list[@]}]}"
echo "Second element: $programming_languages[1]}"
echo "Third element: ${programming_languages[2]}"



# Generate a random number between 0 and 4
random_number=$((RANDOM % 5))

echo "Random number between 0 and 4: $random_number"
