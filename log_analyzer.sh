#!/bin/bash

# Path to the web server access log file
log_file="/var/log/nginx/access.log"  # Update with your web server log file path

# Report file
report_file="log_analysis_report.txt"

# Function to log messages with timestamp
log_message() {
    local log_content="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $log_content" >> "$report_file"
}

# Ensure log file exists
if [ ! -f "$log_file" ]; then
    echo "Error: Log file $log_file not found."
    exit 1
fi

# Analyze 404 errors
log_message "Analyzing 404 Errors:"
num_404_errors=$(awk '$9 == 404 {print}' "$log_file" | wc -l)
log_message "Number of 404 Errors: $num_404_errors"

# Analyze most requested pages
log_message "Analyzing Most Requested Pages:"
most_requested_pages=$(awk '{print $7}' "$log_file" | sort | uniq -c | sort -rn | head -n 10)
log_message "Top 10 Most Requested Pages:"
log_message "$most_requested_pages"

# Analyze top requesting IP addresses
log_message "Analyzing Top Requesting IP Addresses:"
top_ip_addresses=$(awk '{print $1}' "$log_file" | sort | uniq -c | sort -rn | head -n 10)
log_message "Top 10 Requesting IP Addresses:"
log_message "$top_ip_addresses"

# End of script
log_message "Log analysis completed."

# Display report
echo "Log analysis report:"
echo "-------------------"
cat "$report_file"
