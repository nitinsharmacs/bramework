source ../lib/library.sh

TEST_DATA="tests/data"
function test_bind() {
  local test_description=$1
  local expected=$2
  local entry_file=$3

  bind $entry_file > "${TEST_DATA}/bind/actual"

  local expected_file="${TEST_DATA}/bind/expected"
  local actual_file="${TEST_DATA}/bind/actual"
  local actual
  diff ${expected_file} ${actual_file} &> /dev/null
  actual=$?
    
  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="Entry File : $entry_file"
  append_test_case $test_result "bind|$test_description|$inputs|$expected|$actual"
}

function test_cases_bind() {
  local test_description="should bind sourced files"
  local expected=0
  local entry_file="${TEST_DATA}/samples/source.sh"

  test_bind "$test_description" "$expected" "$entry_file"
}

function test_is_file_binded() {
  local test_description=$1
  local expected=$2
  local file=$3
  local binded_files=("${@:4}")

  # echo "in test : binded_files : ${#binded_files[@]}"
  local actual
  is_file_binded $file "${binded_files[@]}"
  actual=$?

  local test_result=$( verify_expectations "$actual" "$expected" )
  local inputs="File : $file, Binded Files : ${binded_files[*]}"
  append_test_case $test_result "is_file_binded|$test_description|$inputs|$expected|$actual"
}

function test_cases_is_file_binded() {
  local test_description="should verify if file already binded"
  local expected=0
  local file="${TEST_DATA}/samples/source.sh"
  # local file="builde.sh"
  local binded_files=("lib/helpers.sh" "${TEST_DATA}/samples/source.sh")
  # local binded_files=("run_tests.sh" "build.sh")
  test_is_file_binded "$test_description" "$expected" "$file" "${binded_files[@]}"

  test_description="should verify if file is not binded"
  expected=1
  file="builde.sh"
  binded_files=("lib/helpers.sh" "${TEST_DATA}/samples/source.sh")
  test_is_file_binded "$test_description" "$expected" "$file" "${binded_files[@]}"
}