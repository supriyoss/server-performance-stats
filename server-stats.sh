#!/bin/bash

os_version() {
    echo "### OS Version ###"
    if [ -f /etc/os-release ]; then
        os=$(grep -w "PRETTY_NAME" /etc/os-release | cut -d '"' -f2)
        echo "Operating System: $os"
    else
    echo "Operating System info not available"
    fi
    echo
}

system_uptime() {
    echo "### Uptime and Load Average ###"
    uptime_info=$(uptime -p)
    load_avg=$(uptime | awk -F 'load average:' '{print $2}')
    echo "System Uptime: $uptime_info"
    echo "Load Average (1 min, 5 min, 15 min):$load_avg"
    echo
}

logged_in_users() {
    echo "### Logged In Users ###"
    who | awk '{print $1}' | sort | uniq -c
    echo
}

failed_logins() {
    echo "### Failed Login Attempts ###"
    if [ -f /var/log/auth.log ]; then
        log_file="/var/log/auth.log"
    elif [ -f /var/log/secure ]; then
        log_file="/var/log/secure"
    else
        echo "Log file for failed logins not found!"
        return
    fi

    failed_attempts=$(grep "Failed password" $log_file | wc -l)
    echo "Number of failed login attempts: $failed_attempts"
    echo
}
cpu_usage() {
    echo "### CPU Usage ###"
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    cpu_used=$(echo "scale=2; 100 - $cpu_idle" | bc)
    echo "Total CPU usage: $cpu_used%"
    echo
}


memory_usage() {
    echo "### Memory Usage ###"
    mem_total=$(free -m | awk '/^Mem/ {print $2}')
    mem_used=$(free -m | awk '/^Mem/ {print $3}')
    mem_free=$(free -m | awk '/^Mem/ {print $4}')
    mem_percent=$(echo "scale=2; $mem_used / $mem_total * 100" | bc)
    echo "Total Memory: ${mem_total}MB"
    echo "Used Memory: ${mem_used}MB"
    echo "Free Memory: ${mem_free}MB"
    echo "Memory Usage: ${mem_percent}%"
    echo
}


disk_usage() {
    echo "### Disk Usage ###"
    disk_total=$(df -h / | awk 'NR==2 {print $2}')
    disk_used=$(df -h / | awk 'NR==2 {print $3}')
    disk_free=$(df -h / | awk 'NR==2 {print $4}')
    disk_percent=$(df -h / | awk 'NR==2 {print $5}')
    echo "Total Disk Space: $disk_total"
    echo "Used Disk Space: $disk_used"
    echo "Free Disk Space: $disk_free"
    echo "Disk Usage: $disk_percent"
    echo
}


top_cpu_proc() {
    echo "### Top 5 Processes by CPU Usage ###"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo
}


top_mem_proc() {
    echo "### Top 5 Processes by Memory Usage ###"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
    echo
}


echo "Server Performance Stats:"
echo "========================="
os_version
system_uptime
logged_in_users
failed_logins
cpu_usage
memory_usage
disk_usage
top_cpu_proc
top_mem_proc
