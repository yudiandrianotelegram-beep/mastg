#!/usr/bin/env bash
set -euo pipefail

# scan_phishing_links.sh
# Scan repo untuk potensi masalah "bukaan tab baru" dan redirect/tracking di HTML/JS dan Android (WebView/Intent).
# Requirement: ripgrep (rg)
# Usage: ./scan_phishing_links.sh [--out DIR] [--exclude path1,path2,...] [--redirectors file.txt]
# Example: ./scan_phishing_links.sh --out reports --exclude node_modules,build --redirectors redirectors.txt

OUT_BASE="reports"
EXCLUDE_DEFAULT=".git,node_modules"
REDIRECTOR_FILE=""
OUT_DIR=""
SCRIPT_NAME="$(basename "$0")"

print_usage() {
  cat <<EOF
Usage: $SCRIPT_NAME [--out DIR] [--exclude path1,path2,...] [--redirectors file.txt]

Options:
  --out DIR            Output root directory (default: reports/<timestamp>)
  --exclude LIST       Comma-separated paths to exclude in addition to .git,node_modules
  --redirectors FILE   File containing newline-separated redirector domains to scan for
  --help               Show this help
EOF
}

# parse args
EXCLUDE_EXTRA=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) OUT_BASE="$2"; shift 2;;
    --exclude) EXCLUDE_EXTRA="$2"; shift 2;;
    --redirectors) REDIRECTOR_FILE="$2"; shift 2;;
    --help) print_usage; exit 0;;
    *) echo "Unknown arg: $1"; print_usage; exit 1;;
  esac
done

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) not found. Install ripgrep and retry."
  exit 2
fi

TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT_DIR="${OUT_BASE}/${TIMESTAMP}"
mkdir -p "$OUT_DIR"

# Build --glob exclude args for rg
IFS=',' read -r -a ex_array <<< "${EXCLUDE_DEFAULT},${EXCLUDE_EXTRA}"
RG_EXCLUDES=()
for e in "${ex_array[@]}"; do
  e_trimmed="$(echo "$e" | sed 's/^ *//;s/ *$//')"
  if [[ -n "$e_trimmed" ]]; then
    RG_EXCLUDES+=( -g "!.${e_trimmed#./}" )
  fi
done

# Helper to run an rg command and save output + count
run_scan() {
  local name="$1"
  shift
  local outfile="${OUT_DIR}/${name}.txt"
  echo "[*] Running scan: $name"
  if rg "${RG_EXCLUDES[@]}" "$@" > "$outfile" 2>/dev/null; then
    true
  else
    # ensure empty file if no matches
    : > "$outfile"
  fi
  local count
  count=$(wc -l < "$outfile" | tr -d ' ')
  echo "$name: $count matches" >> "${OUT_DIR}/summary.counts"
}

# Clear/initialize summary files
: > "${OUT_DIR}/summary.counts"
: > "${OUT_DIR}/full-report.txt"

# Scans
# 1. All anchors opening _blank
run_scan "anchors_all" --pcre2 -n -S '<a[^>]*\btarget\s*=\s*["'\'']?_blank["'\'']?[^>]*>' --glob '*.html' --glob '*.htm' --glob '*.php' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx'

# 2. anchors _blank WITHOUT rel containing noopener/noreferrer
# Approach: find anchors then filter out those with noopener/noreferrer
TMP1="${OUT_DIR}/anchors_all.tmp"
rg "${RG_EXCLUDES[@]}" --pcre2 -n -S '<a[^>]*\btarget\s*=\s*["'\'']?_blank["'\'']?[^>]*>' --glob '*.html' --glob '*.htm' --glob '*.php' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx' > "$TMP1" || true
if [[ -s "$TMP1" ]]; then
  awk -F: '{print $1 ":" $2 ":" substr($0, index($0,$3))}' "$TMP1" > "${OUT_DIR}/anchors_all_parsed.txt" || true
  # filter out lines that have rel with noopener or noreferrer
  rg -v --pcre2 'rel\s*=\s*["'\''][^"'\'']*\b(noopener|noreferrer)\b' "$TMP1" > "${OUT_DIR}/anchors_no_rel.txt" || : 
  run_scan "anchors_no_rel" --files "$(realpath "${OUT_DIR}/anchors_no_rel.txt")" || true
else
  : > "${OUT_DIR}/anchors_no_rel.txt"
  echo "anchors_no_rel: 0 matches" >> "${OUT_DIR}/summary.counts"
fi

# 3. window.open usages
run_scan "window_open" --pcre2 -n -S 'window\.open\s*\([^)]*\)' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx'

# 4. window.open with _blank that lack noopener/opener=null nearby
# We capture lines with _blank and then extract context to inspect manually
run_scan "window_open__blank" --pcre2 -n -S 'window\.open\s*\([^)]*["_'\'']_blank["_'\''][^)]*\)' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx'
# also capture files for manual check of opener=null or w.opener = null
if [[ -s "${OUT_DIR}/window_open__blank.txt" ]]; then
  awk -F: '{print $1}' "${OUT_DIR}/window_open__blank.txt" | sort -u > "${OUT_DIR}/window_open__blank_files.txt"
  # For each file, grep for opener/null/noopener nearby
  echo "=== window.open _blank nearby occurrences (context) ===" >> "${OUT_DIR}/full-report.txt"
  while read -r f; do
    echo "---- $f ----" >> "${OUT_DIR}/full-report.txt"
    rg --pcre2 -n -C3 'opener\s*=|w\.opener|noopener|noreferrer|opener\s*\.|window\.open' "$f" >> "${OUT_DIR}/full-report.txt" || true
  done < "${OUT_DIR}/window_open__blank_files.txt"
fi

# 5. literal URLs/strings containing redirect/tracking params (utm_, redirect=, url=, next=, dest=, r=)
run_scan "redirect_strings" --pcre2 -n -S '["'\''][^"'\'']*(\?|&)(utm_[A-Za-z0-9_]+|redirect=|url=|next=|dest=|r=)[^"'\'']*["'\'']' --glob '*.html' --glob '*.htm' --glob '*.php' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx' --glob '*.java' --glob '*.kt'

# 6. location assignments / redirects in JS
run_scan "location_redirects" --pcre2 -n -S '(location\.href|location\.assign|location\.replace|window\.location)' --glob '*.js' --glob '*.jsx' --glob '*.ts' --glob '*.tsx'

# 7. meta refresh
run_scan "meta_refresh" -n -S '<meta[^>]+http-equiv\s*=\s*["'\'']?refresh["'\'']?[^>]*>' --glob '*.html' --glob '*.htm'

# 8. form actions with tracking
run_scan "forms_with_tracking" --pcre2 -n -S '<form[^>]*\baction\s*=\s*["'\''][^"'\'']*["'\''][^>]*>' --glob '*.html' --glob '*.htm' --glob '*.php' \
  | rg --pcre2 -n '(utm_|redirect=|url=|next=|dest=)' > "${OUT_DIR}/forms_with_tracking.txt" || : 
if [[ -f "${OUT_DIR}/forms_with_tracking.txt" ]]; then
  wc -l < "${OUT_DIR}/forms_with_tracking.txt" | tr -d ' ' >> "${OUT_DIR}/summary.counts" || true
fi

# 9. Android WebView / Intent patterns (Java/Kotlin)
run_scan "android_webview_patterns" --pcre2 -n -S 'shouldOverrideUrlLoading|WebViewClient|onPageStarted|onPageFinished' --glob '*.java' --glob '*.kt'
run_scan "android_intent_patterns" --pcre2 -n -S 'Intent\s*\(\s*Intent\.ACTION_VIEW|startActivity\s*\(\s*new\s+Intent|Uri\.parse\(' --glob '*.java' --glob '*.kt'

# 10. redirector domains scan (if file provided)
if [[ -n "$REDIRECTOR_FILE" && -f "$REDIRECTOR_FILE" ]]; then
  echo "[*] Scanning for known redirector domains from $REDIRECTOR_FILE"
  while read -r d; do
    d_trimmed="$(echo "$d" | sed 's/^ *//;s/ *$//')"
    if [[ -n "$d_trimmed" ]]; then
      run_scan "redirector_domain_$(echo "$d_trimmed" | sed 's/[^a-zA-Z0-9]/_/g')" --pcre2 -n -S "https?://(${d_trimmed//./\\.})" --hidden
    fi
  done < "$REDIRECTOR_FILE"
fi

# Build summary report
echo "Report generated at: $OUT_DIR" > "${OUT_DIR}/report-summary.txt"
echo "" >> "${OUT_DIR}/report-summary.txt"
echo "Counts (per scan):" >> "${OUT_DIR}/report-summary.txt"
cat "${OUT_DIR}/summary.counts" >> "${OUT_DIR}/report-summary.txt"
echo "" >> "${OUT_DIR}/report-summary.txt"

echo "Full report file: ${OUT_DIR}/full-report.txt"
# Append all individual outputs to full-report
echo "=== Detailed matches ===" >> "${OUT_DIR}/full-report.txt"
for f in "${OUT_DIR}"/*.txt; do
  fname="$(basename "$f")"
  echo -e "\n\n===== $fname =====\n" >> "${OUT_DIR}/full-report.txt"
  cat "$f" >> "${OUT_DIR}/full-report.txt"
done

echo "[*] Done. Reports saved under: $OUT_DIR"
echo "[*] Summary:"
cat "${OUT_DIR}/report-summary.txt"
