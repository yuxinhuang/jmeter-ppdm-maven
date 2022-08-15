#!/bin/bash
# arg[1] csv file directory
RESULT_DIR=target/jmeter/results
mvn clean
if [ -d "listener-data" ]; then
	rm -r listener-data/*
else
	mkdir listener-data
fi
{
	read
	while IFS=',', read -r testNum IP port URI username password verb bodyFile numDependencies dependencies numThreads requestsPerThread rampUpTime || [ -n "$rampUpTime" ]
	do
		echo "Test Number : $testNum"
		TEST_DIR=$RESULT_DIR/test-$testNum
		POST_DIR=listener-data/failed-post-requests
		if [ $verb == "POST" ]; then
			mkdir $POST_DIR
		fi

		mvn install -DtestNum=$testNum -DIP=$IP -Dport=$port -DURI=${URI//////} -Dusername=$username -Dpassword=$password -Dverb=$verb -DbodyFile=$bodyFile -DnumDependencies=$numDependencies -Ddependencies=$dependencies -DnumThreads=$numThreads -DrequestsPerThread=$requestsPerThread -DrampUpTime=$rampUpTime -Dreportgenerator.properties.overall_granularity=1000 &
		wait

		mkdir $TEST_DIR
		mv $RESULT_DIR/*.csv $RESULT_DIR/test-$testNum-jtl.csv
		cp $RESULT_DIR/*.csv $TEST_DIR
		rm $RESULT_DIR/*.csv
		mv target/jmeter/logs/*.log target/jmeter/logs/test-$testNum.log
		cp target/jmeter/logs/*.log $TEST_DIR
		rm target/jmeter/logs/*.log
		cp -r target/jmeter/reports/ppdm-test/* $TEST_DIR/dashboard-files
		rm -r target/jmeter/reports/ppdm-test/*
	done
} < src/test/jmeter/data/$1

if [ $verb == "POST" ]; then
	cp -r listener-data/failed-post-requests target/jmeter/results
fi
rm target/jmeter/results/*.csv
rm -r target/jmeter/logs
rm -r target/jmeter/reports
rm -r target/jmeter/testFiles
rm -vr target/????????-????-????-????-????????????