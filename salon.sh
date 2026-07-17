#! /bin/bash
# Salon Appointment Scheduler

#VARIABLES
PSQL="psql --username=freecodecamp --dbname=salon -t -A -F"," -c"
SERVICE_COUNT=$($PSQL "SELECT COUNT(*) FROM services;")
###

#FUNCTIONS
print_services () {
  echo "$($PSQL "SELECT service_id ,name FROM services;")" | while IFS="," read -r id name
    do
      echo -e "$id) $name"
    done
}

main() {
  echo -e "\n~~~~ Crazy Hair Salon ~~~~\n\nWelcome to Crazy Hair Salon, what service do you require?\n"

  while 
    print_services
    read SERVICE_ID_SELECTED
    SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED';")
    [[ -z $SERVICE ]]
  do echo -e "\nWe do not have that service please enter a valid service:"; done

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE")
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE';")
  if [[ -z $PHONE ]]
  then
    echo -e "\nPhone number not found, please enter name:"
    read CUSTOMER_NAME

    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    if [[ $INSERT_CUSTOMER_RESULT == "INSERT 0 1" ]]
    then
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';")
    fi

    INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES('$CUSTOMER_ID', '$SERVICE_TIME', '$SERVICE')")
    if [[ $INSERT_SERVICE_RESULT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi

  else
    CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone='$PHONE'")

    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';")

    INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES('$CUSTOMER_ID', '$SERVICE_TIME', '$SERVICE')")
    if [[ $INSERT_SERVICE_RESULT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi

  fi
    
  
}
###
main