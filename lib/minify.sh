source helpers.sh

function parse() {
  local line=$1

  local separator=";"
   # keywords to make separator as space
  local special_keywords="^do\ *$|^then\ *$|^.*if.*;\ *then|^else|^function.*\(\)|^{$"

  line=$( trim "${line}" )
  if egrep -q "${special_keywords}" <<< "${line}"; then
    separator=" "
  elif egrep -q "^$|^#" <<< "${line}"; then
    return 0
  fi
  echo "${line}" | tr "\n" "${separator}"
}

function minify() {
  local content=$1

  oldIFS=$IFS
  IFS=$'\n'
  echo "#! /bin/bash"
  local line
  for line in ${content}
  do
    parse "${line}"
  done
  IFS=$oldIFS
}