#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    

    #if no winner id found
      if [[ -z $WINNER_ID ]]
      then
      #insert team
        INSERT_WINNING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # Print out message when inserted to DB
        if [[ $INSERT_WINNING_TEAM == "INSERT 0 1" ]]
        then
          echo "$WINNER has been inserted into the teams table."
        fi
      fi
    #get opponent Id
    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

      #if no opponent id 
        if [[ -z $OPPONENT_ID ]]
        then
        #insert opponent id
          INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        #print out message when inserted into DB
            if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
            then
              echo "$OPPONENT has been inserted into the DB"
            fi
        fi  
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
     WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
     OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

     INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
     echo "$WINNER vs $OPPONENT game added"
  fi
done