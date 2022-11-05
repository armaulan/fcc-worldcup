#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# year,round,winner,opponent,winner_goals,opponent_goals

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $YEAR != "year" ]]
    
    then
    # Checking Winner
    GET_WINNER_ID=$($PSQL " select team_id from teams where name='$WINNER' ")

    # If winner_id not exist
    if [[ -z $GET_WINNER_ID ]]
      then

        #Insert winner into teams
        INSERT_WINNER=$($PSQL " insert into teams(name) values('$WINNER') ")

        #Show if insert process is succeed
        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
          then echo Inserted into table teams, $WINNER
          fi

        #Get New inserted winner_id
        GET_WINNER_ID=$($PSQL " select team_id from teams where name='$WINNER' ")
    fi

    # Checking Opponent
    GET_OPPONENT_ID=$($PSQL " select team_id from teams where name='$OPPONENT' ")

    # If Opponent doesn't exist
    if [[ -z $GET_OPPONENT_ID ]]
      then
        #Insert opponent into teams
        INSERT_OPPONENT=$($PSQL " insert into teams(name) values('$OPPONENT') ")

        #Show if insert process is succeed
        if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
          then echo Inserted into table teams, $OPPONENT
          fi

        #Get New inserted winner_id
        GET_OPPONENT_ID=$($PSQL " select team_id from teams where name='$OPPONENT' ")
    fi

    # Insert into games table
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS) ")
    
    # If insert is succeed
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then echo Inserted into table teams, $ROUND
      fi
  fi
done
