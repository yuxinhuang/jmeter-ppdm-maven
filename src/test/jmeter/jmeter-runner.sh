#!/bin/bash
# arg[1] csv file directory

{
	RESULT_DIR=target/jmeter/test-results;
	# Check the file is exists or not
	if [ -d "$RESULT_DIR" ]; then
	   	# Remove  the file with permission
	   	rm -rf $RESULT_DIR;
	  	echo "Removed original $RESULT_DIR folder";
	fi

	read
	while IFS=',', read -r testNum IP port URI username password verb bodyFile numDependencies dependencies numThreads requestsPerThread rampUpTime || [ -n "$rampUpTime" ]
	do
		echo "Test Number : $testNum"
		TEST_DIR=$RESULT_DIR/test-$testNum;
		POST_DIR=$TEST_DIR/failed-post-requests;

		if [ -d "$TEST_DIR" ]; then
    			mkdir $TEST_DIR;
			mkdir $POST_DIR;
		fi
		
		mvn clean install -DtestNum=$testNum -DIP=$IP -Dport=$port -DURI=${URI//////} -Dusername=$username -Dpassword=$password -Dverb=$verb -DbodyFile=$bodyFile -DnumDependencies=$numDependencies -Ddependencies=$dependencies -DnumThreads=$numThreads -DrequestsPerThread=$requestsPerThread -DrampUpTime=$rampUpTime
	done
} < $1