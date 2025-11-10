#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT="$1"

NOT_FOUND() {
  echo "I could not find that element in the database."
}

if [[ -z $ELEMENT ]]
then
  echo "Please provide an element as an argument."
else
  GET_INFO_SQL="SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements AS e JOIN properties AS p ON e.atomic_number=p.atomic_number JOIN types AS t ON p.type_id=t.type_id"
  if [[ "$ELEMENT" =~ [0-9]+ ]]
  then
    GET_BY_ATOMIC_NUMBER=$($PSQL "$GET_INFO_SQL WHERE p.atomic_number=$ELEMENT")
    if [[ -z $GET_BY_ATOMIC_NUMBER ]]
    then
      NOT_FOUND
    else
      echo "$GET_BY_ATOMIC_NUMBER" | while IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE;
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  elif [[ "$ELEMENT" =~ [A-Z]+ ]]
  then
    GET_BY_SYMBOL=$($PSQL "$GET_INFO_SQL WHERE e.symbol='$ELEMENT'")
    if [[ -z $GET_BY_SYMBOL ]]
    then
      GET_BY_NAME=$($PSQL "$GET_INFO_SQL WHERE e.name='$ELEMENT'")
      if [[ -z $GET_BY_NAME ]]
      then
        NOT_FOUND
      else
        echo "$GET_BY_NAME" | while IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE;
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      fi
    else
      echo "$GET_BY_SYMBOL" | while IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE;
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  else
    NOT_FOUND
  fi
fi

