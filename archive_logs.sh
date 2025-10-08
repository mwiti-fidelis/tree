#!/usr/bin/bash

#create path variables
LOG_PATH="hospital_data/active_logs"
HEART_ARCHIVE="hospital_data/archived_logs/heart_data_archive"
TEMP_ARCHIVE="hospital_data/archived_logs/temperature_data_archive"
WATER_ARCHIVE="hospital_data/archived_logs/water_usage_data_archive"

#initialize a menu option prompting for user input

echo "Enter the number corresponding to the file you want to archive: "
echo "1) heart_rate.log"
echo "2) temperature.log"
echo "3) water_usage.log"

read -p "Enter the log file you want to archive by choosing (1-3)" choice

#initiate a condition to update the archival details 

case $choice in

    1) LOG_FILE="$LOG_PATH/heart_rate.log"
       ARCHIVE_PATH="$HEART_ARCHIVE"
       BASENAME="heart_rate"
       ;;

    2) LOG_FILE="$LOG_PATH/temperature.log"
       ARCHIVE_PATH="$TEMP_ARCHIVE"
       BASENAME="temperature"
       ;;

    3) LOG_FILE="$LOG_PATH/water_usage"
       ARCHIVE_PATH="$WATER_ARCHIVE"
       BASENAME="water_usage"
       ;;

    *) echo "Error: Invalid choice, please enter 1,2 or 3"
       exit 1
       ;;

esac

#check if the file exists

if [ ! -f "$LOG_FILE"]; then
    echo "Error! file '$LOG_FILE' does not exist"
    exit 1
fi

#update the naming of the log files so as to include the timestamp
#create a variable for the timestamp format

TIMESTAMP="(date +%y-%m-%d_%H:%M:%S)"
ARCHIVALFILE_NAME="${BASENAME}_${TIMESTAMP}.log"
ARCHIVAL_PATH="$ARCHIVE_PATH/$ARCHIVALFILE_NAME"

#move the file and if successful, create a new log file

if mv "$LOG_FILE" "$ARCHIVAL_PATH" 2>/dev/null; then
    touch "$LOG_FILE"
    echo "successfully archived '$ARCHIVALFILE_NAME' and created '$LOG_FILE'"
else
    echo "Error: failed to move the '$LOG_FILE to the archive directory'"
fi

echo "MISSION SUCCESSFUL========="
