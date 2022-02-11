TESTS=()

function verify_expectations() {
	local actual=$1
	local expected=$2
	local test_result="fail"
	if [[ "$expected" == "$actual" ]]
	then
		test_result="pass"
	fi
	echo $test_result
}

function append_test_case() {
	local test_result=$1
	local data=$2
	
	TESTS[${#TESTS[@]}]="$test_result|${data}"	
}

function get_tests() {
	local test
	
	for test in "${TESTS[@]}"
	do
		echo "$test"
	done
}