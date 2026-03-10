```markdown
# T1 – Comenzi Linux utilizate în audit

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# A) Filesystem


## A1. Listare continut director

Descriere: listeaza continutul directorului curent in format long si include fisierele ascunse.
ls -la > reports/fs/A1_ls_long.txt

Output:
reports/fs/A1_ls_long.txt

-----------------------------------------------------------------------------------------------

## A2. Gasire fisiere .sh

Descriere: gaseste toate fisierele cu extensia `.sh` din proiect.
find . -type f -name "*.sh" > reports/fs/A2_find_sh.txt

Output:
reports/fs/A2_find_sh.txt

-----------------------------------------------------------------------------------------------

## A3. Dimensiune directoare nivel 1

Descriere: afiseaza dimensiunea human-readable pentru directoarele de nivel 1 din proiect.
du -h --max-depth=1 > reports/fs/A3_du_level1.txt

Output:
reports/fs/A3_du_level1.txt


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# B) Procese


## B1. Top 10 procese dupa memorie

Descriere: afiseaza primele 10 procese ordonate descrescator dupa consumul de memorie.
ps aux --sort=-%mem | head -n 11 > reports/process/B1_top_mem.txt

Output:
reports/process/B1_top_mem.txt

-----------------------------------------------------------------------------------------------

## B2. Arbore procese

Descriere: afiseaza arborele de procese al sistemului cu PID-uri.
pstree -p > reports/process/B2_pstree.txt

Output:
reports/process/B2_pstree.txt

-----------------------------------------------------------------------------------------------

## B3. Proces test sleep

Descriere: porneste un proces `sleep 60` în background si îl identifica dupa PID.

sleep 60 &
pgrep -fl sleep > reports/process/B3_pgrep_sleep.txt

Output:
reports/process/B3_pgrep_sleep.txt

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# C) /proc


## C1. Model CPU

Descriere: extrage modelul CPU din `/proc/cpuinfo`.
grep "model name" /proc/cpuinfo | head -n 1 > reports/proc/C1_cpu_model.txt

Output:
reports/proc/C1_cpu_model.txt

-----------------------------------------------------------------------------------------------

## C2. MemTotal si MemAvailable

Descriere: extrage informatiile despre memoria totala si disponibila.
grep -E "MemTotal|MemAvailable" /proc/meminfo > reports/proc/C2_mem_total_avail.txt

Output:
reports/proc/C2_mem_total_avail.txt

-----------------------------------------------------------------------------------------------

## C3. Uptime

Descriere: afiseaza uptime-ul sistemului in secunde.
cut -d " " -f1 /proc/uptime > reports/proc/C3_uptime.txt

Output:
reports/proc/C3_uptime.txt

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# D) Pipeline


## D1. Top 5 fisiere mari din proiect

Descriere: determina cele mai mari 5 fisiere din proiect dupa dimensiune.
find . -type f -exec du -h {} + | sort -hr | head -n 5 | cut -f1,2 > reports/pipeline/D1_top5_large_files.txt

Output:

reports/pipeline/D1_top5_large_files.txt

-----------------------------------------------------------------------------------------------

## D2. Top 5 procese dupa memorie (PID si nume)

Descriere: extrage PID si numele proceselor care consuma cea mai multa memorie.
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | cut -d " " -f1,2 | uniq | head -n 5 > reports/pipeline/D2_top5_proc_mem_pid_name.txt

Output:
reports/pipeline/D2_top5_proc_mem_pid_name.txt

-----------------------------------------------------------------------------------------------

## D3. Numar comenzi din document

Descriere: extrage liniile ce conțin comenzi, le sorteaza si numara cate sunt.
grep ">" doc/T1_comenzi.md | sort | wc -l > reports/pipeline/D3_count_commands.txt

Output:
reports/pipeline/D3_count_commands.txt
