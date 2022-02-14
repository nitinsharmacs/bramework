#! /bin/bash
source lib/library.sh

function main() {
  local command=$1
  local entry_file=$2
  local args=("${@:3}")

  if [[ ${command} == "run" ]]; then
    run "${entry_file}" "${args[@]}"
  elif [[ ${command} == "build" ]]; then
    build "${entry_file}"
  fi
}

main "${@}"