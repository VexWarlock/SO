#!/bin/bash

set -e

LOG_DIR="logs"
REPORT_DIR="reports"
OBJ_DIR="tmp/obj"
BIN_DIR="bin"

mkdir -p "$LOG_DIR" "$REPORT_DIR" "$OBJ_DIR" "$BIN_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/fileops_$TIMESTAMP.log"

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

SUBCOMMAND=$1
shift || true

start_time=$(date +%s)

case "$SUBCOMMAND" in
    init)
        # verificare gcc
        if ! command -v gcc &>/dev/null; then
            echo "gcc nu este instalat. Iesire."
            exit 1
        fi
        mkdir -p bin src include data logs reports tmp/obj tests doc tools
        log "Comanda init executata"
        ;;
    build)
        SRC_DIR="src"
        while [[ $# -gt 0 ]]; do
            case $1 in
                --src)
                    SRC_DIR="$2"
                    shift 2
                    ;;
                *)
                    shift
                    ;;
            esac
        done

        mkdir -p "$OBJ_DIR" "$BIN_DIR"
        objects=()
        main_file=""
        exe=""

        compile_recursive() {
            for file in "$1"/*; do
                if [ -d "$file" ]; then
                    compile_recursive "$file"
                elif [[ "$file" == *.c ]]; then
                    obj="$OBJ_DIR/$(basename "${file%.c}.o")"

                    if [ ! -f "$obj" ] || [ "$file" -nt "$obj" ]; then
                        gcc $CFLAGS -c "$file" -o "$obj"
                    fi

                    # dacă este main_*.c, nu-l adăugăm la objects
                    if [[ "$(basename "$file")" == main_* ]]; then
                        main_file="$file"
                        exe="$BIN_DIR/$(basename "$file" | sed 's/main_\(.*\)\.c/\1/')"
                    else
                        objects+=("$obj")
                    fi
                fi
            done
        }

        compile_recursive "$SRC_DIR"

        if [ ! -z "$main_file" ]; then
            gcc $CFLAGS "$main_file" "${objects[@]}" -o "$exe"
        fi
        log "Comanda build executata"
        ;;
    run)
        if [[ "$1" != "--" ]]; then
            echo "Sintaxa corecta: ./tools/fileops.sh run -- <executabil> [args...]"
            exit 1
        fi
        shift
        exe="$1"
        shift
        if [ ! -x "$BIN_DIR/$exe" ]; then
            echo "Executabilul $exe nu exista."
            exit 1
        fi
        "$BIN_DIR/$exe" "$@"
        log "Comanda run executata: $exe"
        ;;
    clean)
        rm -f "$OBJ_DIR"/* "$BIN_DIR"/*
        log "Comanda clean executata"
        ;;
    test)
        TESTS_DIR="tests"
        REPORT_FILE="$REPORT_DIR/T2_tests.txt"
> "$REPORT_FILE"
        EXIT_CODE=0
        shopt -s globstar
        for test_script in "$TESTS_DIR"/**/*.sh; do
            if [ -f "$test_script" ]; then
                bash "$test_script"
                if [ $? -eq 0 ]; then
                    echo "$(basename "$test_script"): PASS" >> "$REPORT_FILE"
                else
                    echo "$(basename "$test_script"): FAIL" >> "$REPORT_FILE"
                    EXIT_CODE=1
                fi
            fi
        done
        log "Comanda test executata"
        exit $EXIT_CODE
        ;;
    *)
        echo "Subcomanda necunoscuta: $SUBCOMMAND"
        exit 1
        ;;
esac

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Start: $start_time, End: $end_time, Duration: ${duration}s" >> "$LOG_FILE"
echo "Exit code: $?" >> "$LOG_FILE"
