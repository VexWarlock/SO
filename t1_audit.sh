#!/bin/bash

START=$(date +%s)
START_HUMAN=$(date)

mkdir -p reports/fs
mkdir -p reports/process
mkdir -p reports/proc
mkdir -p reports/pipeline

# Filesystem
ls -la > reports/fs/A1_ls_long.txt
find . -type f -name "*.sh" > reports/fs/A2_find_sh.txt
du -h --max-depth=1 > reports/fs/A3_du_level1.txt

# Procese
ps aux --sort=-%mem | head -n 11 > reports/process/B1_top_mem.txt
pstree -p > reports/process/B2_pstree.txt

sleep 60 &
SLEEP_PID=$!

pgrep -fl sleep > reports/process/B3_pgrep_sleep.txt

# /proc
grep "model name" /proc/cpuinfo | head -n 1 > reports/proc/C1_cpu_model.txt
grep -E "MemTotal|MemAvailable" /proc/meminfo > reports/proc/C2_mem_total_avail.txt
cut -d " " -f1 /proc/uptime > reports/proc/C3_uptime.txt

# Pipeline
find . -type f -exec du -h {} + | sort -hr | head -n 5 | cut -f1,2 > reports/pipeline/D1_top5_large_files.txt
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | cut -d " " -f1,2 | uniq | head -n 5 > reports/pipeline/D2_top5_proc_mem_pid_name.txt
grep ">" doc/T1_comenzi.md | sort | wc -l > reports/pipeline/D3_count_commands.txt

END=$(date +%s)
END_HUMAN=$(date)

DURATION=$((END-START))

echo "Start: $START_HUMAN" > reports/T1_summary.txt
echo "End: $END_HUMAN" >> reports/T1_summary.txt
echo "Durata (secunde): $DURATION" >> reports/T1_summary.txt
echo "Directoare generate:" >> reports/T1_summary.txt
echo "reports/fs" >> reports/T1_summary.txt
echo "reports/process" >> reports/T1_summary.txt
echo "reports/proc" >> reports/T1_summary.txt
echo "reports/pipeline" >> reports/T1_summary.txt

kill $SLEEP_PID
