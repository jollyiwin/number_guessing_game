#!/bin/bash

<<<<<<< HEAD
# Connect to the database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate a random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))

=======
# Database connection setup
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ensure the database exists
$PSQL "CREATE TABLE IF NOT EXISTS users(username VARCHAR(22) PRIMARY KEY, games_played INT DEFAULT 0, best_game INT DEFAULT 1000);"

# Generate a random number
SECRET_NUMBER=$((RANDOM % 1000 + 1))

# Ask for username
>>>>>>> 955068d (Initial commit)
echo "Enter your username:"
read USERNAME

# Fetch user data
<<<<<<< HEAD
USER_DATA=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_DATA ]]; then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, NULL)"
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Returning user
IFS="|" read USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_DATA"

  # Ensure best_game is displayed correctly
  if [[ -z $BEST_GAME ]]; then
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game has not been recorded yet."
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
fi

# Start guessing game
echo "Guess the secret number between 1 and 1000:"
GUESSES=0

while true; do
  read GUESS

  # Validate input
  if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
=======
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
>>>>>>> 955068d (Initial commit)
    echo "That is not an integer, guess again:"
    continue
  fi

<<<<<<< HEAD
  ((GUESSES++))

  if [[ $GUESS -lt $SECRET_NUMBER ]]; then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
=======
  if (( GUESS < SECRET_NUMBER )); then
    echo "It's higher than that, guess again:"
  elif (( GUESS > SECRET_NUMBER )); then
>>>>>>> 955068d (Initial commit)
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

<<<<<<< HEAD
# Update user stats
$PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id = $USER_ID"

if [[ -z $BEST_GAME || $BEST_GAME -eq 0 || $GUESSES -lt $BEST_GAME ]]; then
  $PSQL "UPDATE users SET best_game = $GUESSES WHERE user_id = $USER_ID"
fi
=======
# Update database
$PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$USERNAME'"
$PSQL "UPDATE users SET best_game = LEAST(best_game, $GUESSES) WHERE username='$USERNAME'"

>>>>>>> 955068d (Initial commit)
