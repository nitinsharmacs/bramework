source lib/library.sh

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