#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ELEMENT_INFO() {
ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed 's/ |/"/')

NAME=$($PSQL "SELECT e.name FROM elements e WHERE e.atomic_number=$ATOMIC_NUMBER")
NAME_FORMATTED=$(echo $NAME | sed 's/ |/"/')

SYMBOL=$($PSQL "SELECT e.symbol FROM elements e WHERE e.atomic_number=$ATOMIC_NUMBER")
SYMBOL_FORMATTED=$(echo $SYMBOL | sed 's/ |/"/')

TYPE=$($PSQL "SELECT t.type FROM elements e INNER JOIN properties p USING(atomic_number) INNER JOIN types t USING(type_id) WHERE e.atomic_number=$ATOMIC_NUMBER")
TYPE_FORMATTED=$(echo $TYPE | sed 's/ |/"/')

ATOMIC_MASS=$($PSQL "SELECT p.atomic_mass FROM elements e INNER JOIN properties p USING(atomic_number) WHERE e.atomic_number=$ATOMIC_NUMBER")
ATOMIC_MASS_FORMATTED=$(echo $ATOMIC_MASS | sed 's/ |/"/')

MELTING_POINT=$($PSQL "SELECT p.melting_point_celsius FROM elements e INNER JOIN properties p USING(atomic_number) WHERE e.atomic_number=$ATOMIC_NUMBER")
MELTING_POINT_FORMATTED=$(echo $MELTING_POINT | sed 's/ |/"/')

BOILING_POINT=$($PSQL "SELECT p.boiling_point_celsius FROM elements e INNER JOIN properties p USING(atomic_number) WHERE e.atomic_number=$ATOMIC_NUMBER")
BOILING_POINT_FORMATTED=$(echo $BOILING_POINT | sed 's/ |/"/')

echo -e "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MELTING_POINT_FORMATTED celsius and a boiling point of $BOILING_POINT_FORMATTED celsius."
}


if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  INPUT=$1
  #check if argument is a number
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    #check if argument is in database
    CHECK=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.atomic_number=$INPUT")
    if [[ -z $CHECK ]]
    then
      echo -e 'I could not find that element in the database.'
    else
      ATOMIC_NUMBER=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.atomic_number=$INPUT")
      ELEMENT_INFO
    fi
  
  #check if argument has three or more characters
  elif [[ $INPUT =~ ^.{3,}$ ]]
  then
    #check if argument is in database
    CHECK=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.name='$INPUT'")
    if [[ -z $CHECK ]]
    then
      echo -e 'I could not find that element in the database.'
    else
      ATOMIC_NUMBER=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.name='$INPUT'")
      ELEMENT_INFO
    fi
  

  #check if argument has one or two characters
  elif [[ $INPUT =~ ^.{1,2}$ ]]
  then
    #check if argument is in database
    CHECK=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.symbol='$INPUT'")
    if [[ -z $CHECK ]]
    then
      echo -e 'I could not find that element in the database.'
    else
      ATOMIC_NUMBER=$($PSQL "SELECT e.atomic_number FROM elements e WHERE e.symbol='$INPUT'")
      ELEMENT_INFO
    fi
  fi
fi
