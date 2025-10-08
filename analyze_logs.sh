 #!/bin/bash

#defining variables for easier access

HEART_LOG="hospital_data/active_logs/heart_rate.log"
TEMP_LOG="hospital_data/active_logs/temperature.log"
WATER_LOG="hospital_data/active_logs/water_usage.log"
REPORT_FILE="hospital_data/reports/analysis_report.txt"

#create or check whether the path to the file exists

mkdir -p "$(dirname "$REPORT_FILE")"

#creating the menu

echo "select log file to analyze:"
echo "1) Heart Rate (heart_rate.log)"
echo "2) Temperature (temperature.log)"
echo "3) Water usage (water_usage.log)"
#get user input on the log file

read -p "Enter your choice (1-3): " choice                                  
case "$choice" in
    1) selected_log="$HEART_LOG"
       log_name="Heart rate"
       break
       ;;

    2) selected_log="$TEMP_LOG"
       log_name="Temperature"
       break
       ;;

    3) selected_log="$WATER_LOG"
       log_name="Water usage"
       break
       ;;                 
    
    *) echo "Invalid choice: Please enter 1, 2, or 3."
       exit 1

esac

#check whether the file exists and print an error message if it does not
if [ ! -f "selected_log" ]; then
    echo "log file 'selected_log' not found!"
    exit 1
fi
{
  echo "----------------------------------------"
  echo "Analysis Report for $log_name"
  echo "Date: $(date)"
  echo ""
  echo "Device Activity Summary:"
} >> "$REPORT_FILE"
awk '{print $1}' "$selected_log" | sort | uniq -c | awk '{printf "  %s: %d entries\n", $2, $1}' >> "$REPORT_FILE"
first_ts=$(awk 'NF{print $2; exit}' "$selected_log")
last_ts=$(awk 'NF{t=$2} END{if (t) print t; else print "N/A"}' "$selected_log")
{
  echo ""
  echo "First Entry Timestamp: ${first_ts:-N/A}"
  echo "Last Entry Timestamp:  ${last_ts:-N/A}"
  echo "----------------------------------------"
  echo ""
} >> "$REPORT_FILE"
echo ""
echo "Analysis complete for: $log_name"
echo "Results appended to: $REPORT_FILE"
echo ""
