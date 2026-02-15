#!/usr/bin/env bash
# kegg_fetch.sh - Fetch data from the KEGG REST API
#
# Usage:
#   kegg_fetch.sh <operation> [args...]
#
# Operations:
#   info <database>
#   list <database> [org]
#   find <database> <query> [option]
#   get <dbentries> [option]
#   conv <target_db> <source_db_or_entries> [option]
#   link <target_db> <source_db_or_entries> [option]
#   ddi <dbentries>
#
# Examples:
#   kegg_fetch.sh info pathway
#   kegg_fetch.sh list pathway hsa
#   kegg_fetch.sh find compound sugar
#   kegg_fetch.sh get hsa:10458 aaseq
#   kegg_fetch.sh conv uniprot hsa
#   kegg_fetch.sh link pathway hsa:10458
#   kegg_fetch.sh ddi D00564+D00123

set -euo pipefail

BASE_URL="https://rest.kegg.jp"

usage() {
  sed -n '2,/^[^#]/{ /^#/s/^# \{0,1\}//p; }' "${0}"
  exit 1
}

# URL-encode a string (spaces become +, special chars become %XX)
urlencode() {
  python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "${1}"
}

if [[ ${#} -lt 1 ]]; then
  usage
fi

operation="${1}"
shift

case "${operation}" in
  info)
    [[ ${#} -lt 1 ]] && { echo "Error: info requires <database>" >&2; exit 1; }
    url="${BASE_URL}/info/${1}"
    ;;
  list)
    [[ ${#} -lt 1 ]] && { echo "Error: list requires <database>" >&2; exit 1; }
    url="${BASE_URL}/list/${1}"
    [[ ${#} -ge 2 ]] && url="${url}/${2}"
    ;;
  find)
    [[ ${#} -lt 2 ]] && { echo "Error: find requires <database> <query>" >&2; exit 1; }
    encoded_query=$(urlencode "${2}")
    url="${BASE_URL}/find/${1}/${encoded_query}"
    [[ ${#} -ge 3 ]] && url="${url}/${3}"
    ;;
  get)
    [[ ${#} -lt 1 ]] && { echo "Error: get requires <dbentries>" >&2; exit 1; }
    url="${BASE_URL}/get/${1}"
    [[ ${#} -ge 2 ]] && url="${url}/${2}"
    ;;
  conv)
    [[ ${#} -lt 2 ]] && { echo "Error: conv requires <target_db> <source>" >&2; exit 1; }
    url="${BASE_URL}/conv/${1}/${2}"
    [[ ${#} -ge 3 ]] && url="${url}/${3}"
    ;;
  link)
    [[ ${#} -lt 2 ]] && { echo "Error: link requires <target_db> <source>" >&2; exit 1; }
    url="${BASE_URL}/link/${1}/${2}"
    [[ ${#} -ge 3 ]] && url="${url}/${3}"
    ;;
  ddi)
    [[ ${#} -lt 1 ]] && { echo "Error: ddi requires <dbentries>" >&2; exit 1; }
    url="${BASE_URL}/ddi/${1}"
    ;;
  *)
    echo "Error: unknown operation '${operation}'" >&2
    echo "Valid operations: info, list, find, get, conv, link, ddi" >&2
    exit 1
    ;;
esac

# Stream output directly to stdout to preserve binary data (e.g., PNG images)
curl -sf --max-time 30 "${url}" || {
  status=${?}
  echo "Error: KEGG API request failed (curl exit code: ${status})" >&2
  echo "URL: ${url}" >&2
  exit 1
}
