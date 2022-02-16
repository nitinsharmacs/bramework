#! /bin/bash
source lib/library.sh

function main() {
  local command=$1
  local args=("${@:2}")

  if [[ ${command} == "run" ]]; then
    run "${args[@]}"
  elif [[ ${command} == "build" ]]; then
    build "${args[@]}"
  elif [[ ${command} == "deploy" ]]; then
    deploy "${args[@]}"
  fi
}

main "${@}"