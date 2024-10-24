#!/bin/bash

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
cpu_usage
memory_usage
disk_usage
top_cpu_proc
top_mem_proc
