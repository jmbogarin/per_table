#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  DATA=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
else
  DATA=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
fi

if [[ -z $DATA ]]
then
  echo "I could not find that element in the database."
else
  arrDATA=(${DATA//|/})
  echo "The element with atomic number ${arrDATA[0]} is ${arrDATA[1]} (${arrDATA[2]}). It's a ${arrDATA[3]}, with a mass of ${arrDATA[4]} amu. ${arrDATA[1]} has a melting point of ${arrDATA[5]} celsius and a boiling point of ${arrDATA[6]} celsius."
fi
