#! /bin/bash

source tests/general_test_functions.sh
source tests/generate_report.sh
source tests/test_library.sh
source tests/test_helpers.sh

function run_all_tests() {
  local test_dir="tests"
  local test_files=()
  test_files[0]="${test_dir}/test_library.sh"
  test_files[1]="${test_dir}/test_helpers.sh"

  local test_cases=($(get_test_cases "${test_files[@]}"))

  OLDIFS=${IFS}
	IFS=$'\n'
  for test_case in ${test_cases[@]}
  do
    ${test_case}
  done
  IFS=${OLDIFS}
}

function run_tests() {
	run_all_tests
	
	OLDIFS=${IFS}
	IFS=$'\n'
	local tests=($(get_tests))
	IFS=${OLDIFS}
	
	generate_report "${tests[@]}"
}

run_tests