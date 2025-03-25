#!/bin/bash

# Connect to the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate a random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))

echo "Enter your username:"
read USERNAME

# Fetch user data
USER_DATA=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_DATA ]]; then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL)"
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Returning user
  IFS="|" read USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Start guessing game
echo "Guess the secret number between 1 and 1000:"
GUESSES=0

while true; do
  read GUESS

  # Validate input
  if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESSES++))

  if [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

# Update user stats
if [[ -z $BEST_GAME || $GUESSES -lt $BEST_GAME ]]; then
  $PSQL "UPDATE users SET best_game=$GUESSES WHERE user_id=$USER_ID"
fi
$PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID"
