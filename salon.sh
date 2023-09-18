#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

MAIN_MENU () {
  echo -e "\nHi there, welcome to the hair salon!"
  echo -e "\nWhat would you like today?\n1) Haircut\n2) Wash\n3) Destroy\n4) Beer"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1)  HAIRCUT ;;
    2)  WASH ;;
    3)  DESTROY;;
    4)  BEER ;;
    *)  MAIN_MENU ;;
  esac

}

HAIRCUT () {
 #Enter Someone for a haircut
 SERVICE="Haircut"
 CHECK_USER
 ADD_SERVICE
 #SHOW_TABLES

 }

WASH () {
  #Enter Someone for a wash
  SERVICE="Wash"
  CHECK_USER
  ADD_SERVICE
  #SHOW_TABLES

}

DESTROY () {
  #Enter Someone for a destroy
  SERVICE="Destroy"
  CHECK_USER
  ADD_SERVICE
  #SHOW_TABLES

}

BEER () {
  #Enter Someone for a beer
  SERVICE="Beer"
  CHECK_USER
  ADD_SERVICE
  #SHOW_TABLES

}

#Check the user exists in the datase and make a new user if they do not
CHECK_USER () {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  #Check if customers phone number exists in the database
  PHONE_FOUND=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #echo "Customer Phone Number is: $CUSTOMER_PHONE"
  #echo "Phone is found?: $PHONE_FOUND"

  #If customers phone number does not exist in database insert it as new customer
  if [[ -z $PHONE_FOUND ]] 
  then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME

    #Enter new user details into database
    NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    PHONE_FOUND=$($PSQL "SELECT customer_id FROM customers where phone='$CUSTOMER_PHONE'")
    #echo "Succesfully added new customer?: $NEW_CUSTOMER_RESULT"
  else 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")
    echo -e "\nHi $CUSTOMER_NAME"
  fi

  #Get customer_id from entered phone number
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone='$CUSTOMER_PHONE'")
  #echo "Customer ID is: $CUSTOMER_ID"
}

ADD_SERVICE () {
  echo -e "\nWhat time would you like to book for:"
  read SERVICE_TIME

  #Add new appointment into appointments database with time previously entered and current user information
  INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  #echo "Did it insert appointment?: $INSERT_SERVICE_RESULT"
  echo -e "\n\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n\n"
}

SHOW_TABLES () {
  echo -e "\n\n$($PSQL "SELECT * FROM customers")"
  echo -e "\n\n$($PSQL "SELECT * FROM appointments")"
}

MAIN_MENU