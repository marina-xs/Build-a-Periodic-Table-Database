#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#echo "$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id);")"

if [[ $1 ]]
then
  #see if the input is a number or character(s)
  if [[ $1 =~ [0-9] ]]
  then
    SEARCH_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
    #echo "$SEARCH_RESULT"
    #echo "number"
  else
    SEARCH_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
    #echo "$SEARCH_RESULT"
    #echo "not number"
  fi
  #see it exist in the database or not
  if [[ -z $SEARCH_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $SEARCH_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      #echo "$ATOMIC_NUMBER $SYMBOL $NAME $ATOMIC_MASS $MELTING_POINT_CELSIUS $BOILING_POINT_CELSIUS $TYPE_ID $TYPE"
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done 
  fi
else 
  echo "Please provide an element as an argument."
fi
