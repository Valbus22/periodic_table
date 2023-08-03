#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number,symbol,elements.name,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number=$1")
  else
    ELEMENT=$($PSQL "SELECT atomic_number,symbol,elements.name,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.name='$1' OR elements.symbol='$1'")
  fi
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS=" | " read ATOMIC_NUM SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo -e "Please provide an element as an argument."
fi
