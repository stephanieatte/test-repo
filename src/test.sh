#!/bin/bash

# Declare an array named 'myArray'
programming_languages=('Bash' 'Python' 'JavaScript' 'Ruby', 'Java')

# Print the entire array
echo "Elements of myArray: ${programming_languages[@]}"


# Generate a random number between 0 and 4
random_number=$((RANDOM % 5))

echo "Random number between 0 and 4: $random_number"

# Guess the user's preferred language
echo "trying to guess your preferred language: ${programming_languages[$random_number]}"
echo "Second element: $programming_languages[1]}"
echo "Third element: ${programming_languages[2]}"



