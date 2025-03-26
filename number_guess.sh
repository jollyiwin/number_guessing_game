#!/bin/bash

# Database connection setup
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ensure the database exists
$PSQL "CREATE TABLE IF NOT EXISTS users ( username VARCHAR(22) PRIMARY KEY, games_played INT DEFAULT 0, best_game INT DEFAULT NULL);"

# Generate a random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))

# Ask for username
echo "Enter your username:"
read USERNAME

# Fetch user data
USER_DATA=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_DATA ]]; then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME')"
else
  IFS='|' read -r GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Start game
echo "Guess the secret number between 1 and 1000:"
GUESSES=0
while true; do
  read GUESS
  ((GUESSES++))

  if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  if (( GUESS < SECRET_NUMBER )); then
    echo "It's higher than that, guess again:"
  elif (( GUESS > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

# Update database
$PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$USERNAME'"
$PSQL "UPDATE users SET best_game = LEAST(COALESCE(best_game, $GUESSES), $GUESSES) WHERE username='$USERNAME'"