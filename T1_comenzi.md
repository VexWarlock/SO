
---

# 3️⃣ `doc/T1_comenzi.md`

```markdown
# T1 – Comenzi Linux utilizate în audit

---

# A) Filesystem

## A1. Listare conținut director

Descriere: listează conținutul directorului curent în format long și include fișierele ascunse.

Comandă:

ls -la > reports/fs/A1_ls_long.txt

Output:

reports/fs/A1_ls_long.txt

---

## A2. Găsire fișiere .sh

Descriere: găsește toate fișierele cu extensia `.sh` din proiect.

Comandă:

find . -type f -name "*.sh" > reports/fs/A2_find_sh.txt

Output:

reports/fs/A2_find_sh.txt

---

## A3. Dimensiune directoare nivel 1

Descriere: afișează dimensiunea human-readable pentru directoarele de nivel 1 din proiect.

Comandă:

du -h --max-depth=1 > reports/fs/A3_du_level1.txt

Output:

reports/fs/A3_du_level1.txt

---

# B) Procese

## B1. Top 10 procese după memorie

Descriere: afișează primele 10 procese ordonate descrescător după consumul de memorie.

Comandă:

ps aux --sort=-%mem | head -n 11 > reports/process/B1_top_mem.txt

Output:

reports/process/B1_top_mem.txt

---

## B2. Arbore procese

Descriere: afișează arborele de procese al sistemului cu PID-uri.

Comandă:

pstree -p > reports/process/B2_pstree.txt

Output:

reports/process/B2_pstree.txt

---

## B3. Proces test sleep

Descriere: pornește un proces `sleep 60` în background și îl identifică după PID.

Comandă:

sleep 60 &
pgrep -fl sleep > reports/process/B3_pgrep_sleep.txt

Output:

reports/process/B3_pgrep_sleep.txt

Pentru oprirea procesului ulterior:

kill PID

---

# C) /proc

## C1. Model CPU

Descriere: extrage modelul CPU din `/proc/cpuinfo`.

Comandă:

grep "model name" /proc/cpuinfo | head -n 1 > reports/proc/C1_cpu_model.txt

Output:

reports/proc/C1_cpu_model.txt

---

## C2. MemTotal și MemAvailable

Descriere: extrage informațiile despre memoria totală și disponibilă.

Comandă:

grep -E "MemTotal|MemAvailable" /proc/meminfo > reports/proc/C2_mem_total_avail.txt

Output:

reports/proc/C2_mem_total_avail.txt

---

## C3. Uptime

Descriere: afișează uptime-ul sistemului în secunde.

Comandă:

cut -d " " -f1 /proc/uptime > reports/proc/C3_uptime.txt

Output:

reports/proc/C3_uptime.txt

---

# D) Pipeline

## D1. Top 5 fișiere mari din proiect

Descriere: determină cele mai mari 5 fișiere din proiect după dimensiune.

Comandă:

find . -type f -exec du -h {} + | sort -hr | head -n 5 | cut -f1,2 > reports/pipeline/D1_top5_large_files.txt

Output:

reports/pipeline/D1_top5_large_files.txt

---

## D2. Top 5 procese după memorie (PID și nume)

Descriere: extrage PID și numele proceselor care consumă cea mai multă memorie.

Comandă:

ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | cut -d " " -f1,2 | uniq | head -n 5 > reports/pipeline/D2_top5_proc_mem_pid_name.txt

Output:

reports/pipeline/D2_top5_proc_mem_pid_name.txt

---

## D3. Număr comenzi din document

Descriere: extrage liniile ce conțin comenzi, le sortează și numără câte sunt.

Comandă:

grep ">" doc/T1_comenzi.md | sort | wc -l > reports/pipeline/D3_count_commands.txt

Output:

reports/pipeline/D3_count_commands.txt
