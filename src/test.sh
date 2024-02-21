#!/bin/bash

# Declare an array named 'myArray'
programming_languages=('Bash' 'Python' 'JavaScript' 'Ruby', 'Java')

# Print the entire array
echo "Elements of myArray: ${programming_languages[@]}"

# Generate a random number between 0 and 4
random_number=$((RANDOM % 5))

# Guess the user's preferred language
echo "We guess your preferred language is: ${programming_languages[$random_number]}"


if [[ "${preferred_language}" == "${programming_languages[$random_number]}" ]]; then
    echo "Yaay, we guessed correct, it's ${preferred_language}"
else
    echo "We guessed wrong, it's ${preferred_language}"
fi

