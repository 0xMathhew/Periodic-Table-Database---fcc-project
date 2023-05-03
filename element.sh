PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

# check if there is an argument
if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
  exit
fi

# find element in the database and assign in to the variable
ELEMENT=$($PSQL "SELECT * FROM elements WHERE CONCAT(atomic_number, symbol, name) LIKE '%$1%' LIMIT 1;")
# check if element exist in the database
if [[ -z $ELEMENT ]]; then
  echo -e "I could not find that element in the database."
  exit
fi

echo "$ELEMENT" | sed -e 's/|/ /g' | while IFS=" " read ATOMIC_NUMBER SYMBOL NAME
do
# query database to find needed values
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  TYPE_NAME=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")

  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
