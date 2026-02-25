start_log_output() {
  local ANSI_SAVE_CURSOR="\033[s"
  local ANSI_RESTORE_CURSOR="\033[u"
  local ANSI_CLEAR_LINE="\033[2K"
  local ANSI_HIDE_CURSOR="\033[?25l"
  local ANSI_RESET="\033[0m"
  local ANSI_GRAY="\033[90m"

  # Save cursor position and hide cursor
  printf $ANSI_SAVE_CURSOR
  printf $ANSI_HIDE_CURSOR

  (
    local log_lines=20
    local max_line_width=$((LOGO_WIDTH - 4))

    while true; do
      # Read the last N lines into an array
      mapfile -t current_lines < <(tail -n $log_lines "$DEBIAN_INSTALL_LOG_FILE" 2>/dev/null)

      # Build complete output buffer with escape sequences
      output=""
      for ((i = 0; i < log_lines; i++)); do
        line="${current_lines[i]:-}"

        # Truncate if needed
        if (( ${#line} > max_line_width )); then
          line="${line:0:$max_line_width}..."
        fi

        # Add clear line escape and formatted output for each line
        if [[ -n $line ]]; then
          output+="${ANSI_CLEAR_LINE}${ANSI_GRAY}${PADDING_LEFT_SPACES}  → ${line}${ANSI_RESET}\n"
        else
          output+="${ANSI_CLEAR_LINE}${PADDING_LEFT_SPACES}\n"
        fi
      done

      printf "${ANSI_RESTORE_CURSOR}%b" "$output"

      sleep 0.1
    done
  ) &
  monitor_pid=$!
}

stop_log_output() {
  if [[ -n ${monitor_pid:-} ]]; then
    kill $monitor_pid 2>/dev/null || true
    wait $monitor_pid 2>/dev/null || true
    unset monitor_pid
  fi
}

start_install_log() {
  sudo touch "$DEBIAN_INSTALL_LOG_FILE"
  sudo chmod 666 "$DEBIAN_INSTALL_LOG_FILE"

  export DEBIAN_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

  echo "=== Debian Installation Started: $DEBIAN_START_TIME ===" >>"$DEBIAN_INSTALL_LOG_FILE"
  start_log_output
}

stop_install_log() {
  stop_log_output
  show_cursor

  if [[ -n ${DEBIAN_INSTALL_LOG_FILE:-} ]]; then
    DEBIAN_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== Debian Installation Completed: $DEBIAN_END_TIME ===" >>"$DEBIAN_INSTALL_LOG_FILE"
    echo "" >>"$DEBIAN_INSTALL_LOG_FILE"
    echo "=== Installation Time Summary ===" >>"$DEBIAN_INSTALL_LOG_FILE"

    if [[ -f "$DEBIAN_INSTALL/log/install.log" ]]; then
      DEBINSTALL_START=$(grep -m1 '^\[' $DEBIAN_INSTALL/log/install.log 2>/dev/null | sed 's/^\[\([^]]*\)\].*/\1/' || true)
      DEBINSTALL_END=$(grep 'Installation completed without any errors' $DEBIAN_INSTALL/log/install.log 2>/dev/null | sed 
's/^\[\([^]]*\)\].*/\1/' || true)

      if [[ -n $DEBINSTALL_START ]] && [[ -n $DEBINSTALL_END ]]; then
        DEB_START_EPOCH=$(date -d "$DEBINSTALL_START" +%s)
        DEB_END_EPOCH=$(date -d "$DEBINSTALL_END" +%s)
        DEB_DURATION=$((DEB_END_EPOCH - DEB_START_EPOCH))

        DEB_MINS=$((DEB_DURATION / 60))
        DEB_SECS=$((DEB_DURATION % 60))

        echo "Debian installation: ${DEB_MINS}m ${DEB_SECS}s" >>"$DEBIAN_INSTALL_LOG_FILE"
      fi
    fi

    if [[ -n $DEBIAN_START_TIME ]]; then
      DEBIAN_START_EPOCH=$(date -d "$DEBIAN_START_TIME" +%s)
      DEBIAN_END_EPOCH=$(date -d "$DEBIAN_END_TIME" +%s)
      DEBIAN_DURATION=$((DEBIAN_END_EPOCH - DEBIAN_START_EPOCH))

      DEBIAN_MINS=$((DEBIAN_DURATION / 60))
      DEBIAN_SECS=$((DEBIAN_DURATION % 60))

      echo "Debian:     ${DEBIAN_MINS}m ${DEBIAN_SECS}s" >>"$DEBIAN_INSTALL_LOG_FILE"

      if [[ -n $DEB_DURATION ]]; then
        TOTAL_DURATION=$((DEB_DURATION + DEBIAN_DURATION))
        TOTAL_MINS=$((TOTAL_DURATION / 60))
        TOTAL_SECS=$((TOTAL_DURATION % 60))
        echo "Total:       ${TOTAL_MINS}m ${TOTAL_SECS}s" >>"$DEBIAN_INSTALL_LOG_FILE"
      fi
    fi
    echo "=================================" >>"$DEBIAN_INSTALL_LOG_FILE"

    echo "Rebooting system..." >>"$DEBIAN_INSTALL_LOG_FILE"
  fi
}

run_logged() {
  local script="$1"

  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >>"$DEBIAN_INSTALL_LOG_FILE"

  # Use bash -c to create a clean subshell
  bash -c "source '$script'" </dev/null >>"$DEBIAN_INSTALL_LOG_FILE" 2>&1

  local exit_code=$?

  if (( exit_code == 0 )); then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >>"$DEBIAN_INSTALL_LOG_FILE"
    unset CURRENT_SCRIPT
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >>"$DEBIAN_INSTALL_LOG_FILE"
  fi

  return $exit_code
}
